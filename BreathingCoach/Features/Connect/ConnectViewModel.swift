import Foundation
import Observation
import CapnostreamKit
import SwiftUI

@Observable
final class ConnectViewModel {
    enum DisplayUnit: String, CaseIterable {
        case mmHg
        case kPa

        var label: String { rawValue }

        func convert(fromMmHg value: Double) -> Double {
            self == .mmHg ? value : value * 0.13332
        }
    }

    static let waveformSampleCount = 180

    var isLiveSessionActive: Bool {
        liveSessionTask != nil
    }

    var logs: [ConnectConsoleLog] = []
    var serialDevices: [SerialDevice]?
    var isConnected: Bool = false
    private(set) var isConnecting: Bool = false
    private(set) var connectedDevice: SerialDevice?
    var currentCO2WaveMessage: CO2WaveMessage?
    var currentNummericsMessage: NumericsMessage?

    // MARK: Settings

    var techniqueId: String = BreathingTechnique.default.id
    private(set) var customPaceBreathsPerMinute: Double = 6
    private(set) var targetRange: ClosedRange<Double> = 35...45
    private(set) var units: DisplayUnit = .mmHg

    // MARK: Live session tracking

    private(set) var sessionStartDate: Date?
    private(set) var etco2History: [EtCO2Sample] = []
    private(set) var rrHistory: [Double] = []
    private(set) var timeInTargetSeconds: TimeInterval = 0
    private(set) var waveformSamples: [Double] = Array(repeating: 0.03, count: ConnectViewModel.waveformSampleCount)

    /// All sessions completed this run, oldest first. Persists across connect/disconnect cycles.
    private(set) var completedSessions: [SessionSummary] = []
    var lastSummary: SessionSummary? { completedSessions.last }

    var selectedTechnique: BreathingTechnique { .find(id: techniqueId) }

    private var currentClient: CapnostreamClient?
    private var liveSessionTask: Task<Void, Never>?

    func searchSerialDevices() async {
        try? await Task.sleep(for: .seconds(1))
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
    
    func connect(to device: SerialDevice) async throws {
        isConnecting = true
        defer { isConnecting = false }

        logs.append(ConnectConsoleLog(
            timeStamp: Date(),
            message: "Opening \(device.path) @ \(device.baudRate) baud"
        ))

        let client = try CapnostreamClient(path: device.path)
        self.currentClient = client
        
        try? await Task.sleep(for: .seconds(0.5))

        logs.append(ConnectConsoleLog(
            timeStamp: Date(),
            message: "→ Enable Communication Protocol (0x16)",
            highlightColor: Color.bcAccent
        ))
        
        let deviceID = try await client.enableAndAwaitDeviceID()
        
        try? await Task.sleep(for: .seconds(1))
        
        logs.append(ConnectConsoleLog(
            timeStamp: Date(),
            message: "← Device ID: \(deviceID.deviceName) (\(deviceID.swVersion))",
            highlightColor: Color.bcPositive
        ))
                
        try? await Task.sleep(for: .seconds(0.5))
        
        isConnected = true
        connectedDevice = device
        logs.append(ConnectConsoleLog(
            timeStamp: Date(),
            message: "Connected.",
            highlightColor: Color.bcPositive
        ))

        try? await Task.sleep(for: .seconds(0.75))
    }
    
    func selectTechnique(_ id: String) {
        techniqueId = id
    }

    func setTargetMin(_ value: Double) {
        targetRange = min(value, targetRange.upperBound - 1)...targetRange.upperBound
    }

    func setTargetMax(_ value: Double) {
        targetRange = targetRange.lowerBound...max(value, targetRange.lowerBound + 1)
    }

    func setCustomPace(_ value: Double) {
        customPaceBreathsPerMinute = value
    }

    func setUnits(_ unit: DisplayUnit) {
        units = unit
    }

    func startSession() {
        guard let client = currentClient else { return }

        logs.append(ConnectConsoleLog(
            timeStamp: Date(),
            message: "→ Start Realtime Communication (0x09)",
            highlightColor: Color.bcAccent
        ))

        sessionStartDate = Date()
        etco2History = []
        rrHistory = []
        timeInTargetSeconds = 0
        waveformSamples = Array(repeating: 0.03, count: Self.waveformSampleCount)

        client.startRealtimeCommunication()

        liveSessionTask = Task {
            for await message in client.messages() {
                switch message {
                case let .co2Wave(message):
                    // ~20 Hz waveform sample
                    currentCO2WaveMessage = message
                    appendWaveformSample(message.co2Value)
                    logs.append(ConnectConsoleLog(
                        timeStamp: Date(),
                        message: "← Streaming C02 Wave (\(message.co2Value) @ ~20 Hz",
                        highlightColor: Color.bcPositive
                    ))

                case let .numerics(message):
                    // 1 Hz numeric update
                    currentNummericsMessage = message
                    recordNumerics(message)
                    let numerics = "EtCO₂: \(message.etCO2), RR: \(message.respirationRate), SpO₂: \(message.spO2)"
                    logs.append(ConnectConsoleLog(
                        timeStamp: Date(),
                        message: "← Streaming etCO2 (\(numerics) @ 1 Hz",
                        highlightColor: Color.bcPositive
                    ))
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
        etco2History = []
        rrHistory = []
        timeInTargetSeconds = 0
        waveformSamples = Array(repeating: 0.03, count: Self.waveformSampleCount)
        currentCO2WaveMessage = nil
        currentNummericsMessage = nil
    }

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

    private func appendWaveformSample(_ value: Double) {
        waveformSamples.append(value)
        if waveformSamples.count > Self.waveformSampleCount {
            waveformSamples.removeFirst(waveformSamples.count - Self.waveformSampleCount)
        }
    }

    private func recordNumerics(_ message: NumericsMessage) {
        guard let sessionStartDate else { return }
        let elapsed = Date().timeIntervalSince(sessionStartDate)
        if let etco2 = message.etCO2.doubleValue {
            etco2History.append(EtCO2Sample(elapsed: elapsed, value: etco2))
            if targetRange.contains(etco2) {
                timeInTargetSeconds += 1
            }
        }
        if let rr = message.respirationRate.doubleValue {
            rrHistory.append(rr)
        }
    }

    func disconnect() {
        currentClient?.disableCommunicationProtocol()
        currentClient?.close()
        currentClient = nil
        logs = []
        serialDevices = []
        isConnected = false
        connectedDevice = nil
        stopSessionTracking()

        logs.append(ConnectConsoleLog(
            timeStamp: Date(),
            message: "Disconnected.",
            highlightColor: Color.accentColor
        ))
    }
}
