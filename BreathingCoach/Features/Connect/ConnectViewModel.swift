import CapnostreamKit
import Foundation
import Observation
import SwiftUI

/// Owns the connection to the capnograph and everything derived from it: the console log, the
/// user's training settings, the live session being recorded, and the summaries of finished
/// sessions.
///
/// A single instance is created by `ContentView` and shared by every screen, which is what keeps
/// the Connect, Session, Summary, History and Settings tabs consistent with each other.
///
/// Nothing is persisted: settings and session history live for the lifetime of the process only.
@Observable
final class ConnectViewModel {
    /// Number of waveform samples kept for the scrolling CO₂ trace — at ~20 Hz this is roughly
    /// the last nine seconds of breathing.
    static let waveformSampleCount = 180

    /// Upper bound on retained console lines. The waveform stream logs at ~20 Hz, so without a
    /// cap the log would grow without limit for as long as a session runs.
    private static let maxLogCount = 500

    /// Baseline used to pre-fill the waveform so the trace starts flat rather than empty.
    private static let waveformBaseline = 0.03

    /// A full-width waveform buffer pre-filled with the flat baseline.
    private static var emptyWaveform: [Double] {
        Array(repeating: waveformBaseline, count: waveformSampleCount)
    }

    /// Artificial pauses inserted between handshake steps so the console reads as a sequence of
    /// steps rather than flashing past. They are presentation-only and carry no protocol meaning.
    private enum HandshakeDelay {
        static let beforeEnable: Duration = .seconds(0.5)
        static let afterDeviceID: Duration = .seconds(1)
        static let beforeConnected: Duration = .seconds(0.5)
        static let afterConnected: Duration = .seconds(0.75)
    }

    // MARK: - Connection state

    private(set) var logs: [ConnectConsoleLog] = []
    /// Discovered devices, or `nil` while a scan has not run yet.
    private(set) var serialDevices: [SerialDevice]?
    private(set) var isConnected: Bool = false
    private(set) var isConnecting: Bool = false
    private(set) var connectedDevice: SerialDevice?

    // MARK: - Live monitor readings

    /// The most recent 1 Hz readings, or `nil` before the first arrives.
    private(set) var currentReadings: LiveReadings?

    // MARK: - Settings

    private(set) var techniqueId: String = BreathingTechnique.default.id
    private(set) var customPaceBreathsPerMinute: Double = 6
    private(set) var targetRange: ClosedRange<Double> = 35...45
    private(set) var units: DisplayUnit = .mmHg

    var selectedTechnique: BreathingTechnique { .find(id: techniqueId) }

    // MARK: - Live session tracking

    private(set) var sessionStartDate: Date?
    private(set) var etco2History: [EtCO2Sample] = []
    private(set) var rrHistory: [Double] = []
    private(set) var timeInTargetSeconds: TimeInterval = 0
    private(set) var waveformSamples: [Double] = ConnectViewModel.emptyWaveform

    /// All sessions completed this run, oldest first. Persists across connect/disconnect cycles.
    private(set) var completedSessions: [SessionSummary] = []
    var lastSummary: SessionSummary? { completedSessions.last }

    var isLiveSessionActive: Bool { liveSessionTask != nil }

    private var currentClient: CapnostreamClient?
    private var liveSessionTask: Task<Void, Never>?

    // MARK: - Discovery and connection

    /// Scans for attached serial devices, replacing any previous scan result.
    ///
    /// The leading delay gives the progress view time to appear; scanning itself is near-instant.
    func searchSerialDevices() async {
        try? await Task.sleep(for: .seconds(1))

        guard !DemoMode.isEnabled else {
            serialDevices = DemoMode.devices
            return
        }

        serialDevices = listSerialDevices().map { device in
            SerialDevice(
                name: device.name,
                path: device.path,
                baudRate: device.baudRate,
                communicationProtocol: device.communicationProtocol,
                connectionStatus: .available
            )
        }
    }

    /// Opens the serial port and performs the Capnostream handshake, narrating each step to the
    /// console log.
    ///
    /// - Throws: Any error from opening the port or from the device-ID exchange. The caller is
    ///   expected to route the failure to the failed-connection screen.
    func connect(to device: SerialDevice) async throws {
        isConnecting = true
        defer { isConnecting = false }

        log("Opening \(device.path) @ \(device.baudRate) baud")

        if DemoMode.isEnabled {
            try await connectToDemoDevice(device)
            return
        }

        let client = try CapnostreamClient(path: device.path)
        currentClient = client

        try? await Task.sleep(for: HandshakeDelay.beforeEnable)
        log("→ Enable Communication Protocol (0x16)", highlight: .bcAccent)

        let deviceID = try await client.enableAndAwaitDeviceID()

        try? await Task.sleep(for: HandshakeDelay.afterDeviceID)
        log("← Device ID: \(deviceID.deviceName) (\(deviceID.swVersion))", highlight: .bcPositive)

        try? await Task.sleep(for: HandshakeDelay.beforeConnected)

        isConnected = true
        connectedDevice = device
        log("Connected.", highlight: .bcPositive)

        try? await Task.sleep(for: HandshakeDelay.afterConnected)
    }

    /// Closes the connection, clears the console and discards any session in progress.
    ///
    /// Completed session summaries are deliberately kept, so History survives a reconnect.
    func disconnect() {
        currentClient?.disableCommunicationProtocol()
        currentClient?.close()
        currentClient = nil

        logs = []
        serialDevices = []
        isConnected = false
        connectedDevice = nil
        stopSessionTracking()

        log("Disconnected.", highlight: .bcAccent)
    }

    // MARK: - Settings

    func selectTechnique(_ id: String) {
        techniqueId = id
    }

    /// Sets the lower bound of the target range, keeping it at least 1 mmHg below the upper bound.
    func setTargetMin(_ value: Double) {
        targetRange = min(value, targetRange.upperBound - 1)...targetRange.upperBound
    }

    /// Sets the upper bound of the target range, keeping it at least 1 mmHg above the lower bound.
    func setTargetMax(_ value: Double) {
        targetRange = targetRange.lowerBound...max(value, targetRange.lowerBound + 1)
    }

    func setCustomPace(_ value: Double) {
        customPaceBreathsPerMinute = value
    }

    func setUnits(_ unit: DisplayUnit) {
        units = unit
    }

    // MARK: - Live session

    /// Starts realtime streaming and begins recording a new session.
    ///
    /// Does nothing when no device is connected. Any previously recorded samples are discarded —
    /// call `endSession()` first if the current session should be kept.
    func startSession() {
        guard DemoMode.isEnabled || currentClient != nil else { return }

        log("→ Start Realtime Communication (0x09)", highlight: .bcAccent)

        sessionStartDate = Date()
        resetSessionTracking()

        guard let client = currentClient else {
            startDemoSession()
            return
        }

        client.startRealtimeCommunication()

        liveSessionTask = Task { [weak self] in
            for await message in client.messages() {
                guard let self else { return }
                switch message {
                case let .co2Wave(message):
                    appendWaveformSample(message.co2Value)
                    log("← CO₂ wave: \(message.co2Value) (~20 Hz)", highlight: .bcPositive)

                case let .numerics(message):
                    record(message.liveReadings)
                    let numerics = "EtCO₂: \(message.etCO2), RR: \(message.respirationRate), SpO₂: \(message.spO2)"
                    log("← Numerics: \(numerics) (1 Hz)", highlight: .bcPositive)

                default:
                    break
                }
            }
        }
    }

    /// Discards the current session and returns to the technique picker, keeping the device connected.
    func changeTechnique() {
        stopSessionTracking()
    }

    /// Ends the active session, captures its summary, and returns to the technique picker.
    func endSession() {
        if let summary = makeSummary() {
            completedSessions.append(summary)
        }
        stopSessionTracking()
    }

    private func stopSessionTracking() {
        liveSessionTask?.cancel()
        liveSessionTask = nil
        sessionStartDate = nil
        resetSessionTracking()
        currentReadings = nil
    }

    private func resetSessionTracking() {
        etco2History = []
        rrHistory = []
        timeInTargetSeconds = 0
        waveformSamples = Self.emptyWaveform
    }

    /// Builds a summary of the session in progress, or `nil` when nothing usable was recorded.
    private func makeSummary() -> SessionSummary? {
        guard let sessionStartDate, !etco2History.isEmpty else { return nil }

        let values = etco2History.map(\.value)
        let duration = Date().timeIntervalSince(sessionStartDate)
        let avgEtco2 = values.reduce(0, +) / Double(values.count)
        let avgRR = rrHistory.isEmpty ? 0 : rrHistory.reduce(0, +) / Double(rrHistory.count)
        let pctInTarget = duration > 0 ? Int((timeInTargetSeconds / duration * 100).rounded()) : 0

        return SessionSummary(
            date: Date(),
            duration: duration,
            avgEtco2: avgEtco2,
            peakEtco2: values.max() ?? 0,
            avgRR: avgRR,
            pctInTarget: pctInTarget,
            startEtco2: values.first ?? 0,
            endEtco2: values.last ?? 0,
            history: etco2History,
            targetRange: targetRange,
            techniqueName: selectedTechnique.name
        )
    }

    /// Appends a waveform sample, dropping the oldest so the trace scrolls at a fixed width.
    private func appendWaveformSample(_ value: Double) {
        waveformSamples.append(value)
        if waveformSamples.count > Self.waveformSampleCount {
            waveformSamples.removeFirst(waveformSamples.count - Self.waveformSampleCount)
        }
    }

    /// Records a 1 Hz update into the session history.
    ///
    /// Because updates arrive once per second, an in-range reading counts as one second spent in
    /// the target range.
    private func record(_ readings: LiveReadings) {
        guard let sessionStartDate else { return }

        currentReadings = readings

        let elapsed = Date().timeIntervalSince(sessionStartDate)
        if let etco2 = readings.etco2 {
            etco2History.append(EtCO2Sample(elapsed: elapsed, value: etco2))
            if targetRange.contains(etco2) {
                timeInTargetSeconds += 1
            }
        }
        if let rr = readings.respirationRate {
            rrHistory.append(rr)
        }
    }

    // MARK: - Demo mode

    /// Fakes the handshake for a demo device, keeping `currentClient` nil so nothing touches a port.
    private func connectToDemoDevice(_ device: SerialDevice) async throws {
        try? await Task.sleep(for: HandshakeDelay.beforeEnable)
        log("→ Enable Communication Protocol (0x16)", highlight: .bcAccent)

        try? await Task.sleep(for: HandshakeDelay.afterDeviceID)
        log("← Device ID: \(device.name) (demo)", highlight: .bcPositive)

        try? await Task.sleep(for: HandshakeDelay.beforeConnected)

        isConnected = true
        connectedDevice = device
        log("Connected — DEMO MODE, readings are simulated.", highlight: .bcWarning)

        try? await Task.sleep(for: HandshakeDelay.afterConnected)
    }

    /// Streams synthetic samples at the same rates the monitor would: waveform at 20 Hz, numerics at 1 Hz.
    private func startDemoSession() {
        let generator = DemoSignalGenerator(
            segments: selectedTechnique.segments(customBreathsPerMinute: customPaceBreathsPerMinute)
        )

        liveSessionTask = Task { [weak self] in
            var nextNumerics: TimeInterval = 0

            while !Task.isCancelled {
                try? await Task.sleep(for: .milliseconds(50))

                guard let self, let sessionStartDate else { return }
                let elapsed = Date().timeIntervalSince(sessionStartDate)

                appendWaveformSample(generator.waveformValue(at: elapsed))

                if elapsed >= nextNumerics {
                    nextNumerics = elapsed.rounded(.down) + 1
                    record(generator.readings(at: elapsed))
                }
            }
        }
    }

    // MARK: - Console log

    /// Appends a console line, trimming the oldest lines once the log reaches `maxLogCount`.
    private func log(_ message: String, highlight: Color? = nil) {
        logs.append(ConnectConsoleLog(timeStamp: Date(), message: message, highlightColor: highlight))
        if logs.count > Self.maxLogCount {
            logs.removeFirst(logs.count - Self.maxLogCount)
        }
    }
}
