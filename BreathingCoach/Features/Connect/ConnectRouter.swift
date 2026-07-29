import Foundation
import Observation

/// Drives the Connect screen's step machine: scan → pick a device → handshake → connected or failed.
///
/// It holds navigation state only; the connection itself belongs to `ConnectViewModel`.
@Observable
final class ConnectRouter {
    enum Step {
        case initial
        case searching
        case serialDeviceSelection(devices: [SerialDevice])
        case handshake(device: SerialDevice)
        case connected(device: SerialDevice)
        case failed(device: SerialDevice)
    }

    var currentStep: Step

    private var lastDevices: [SerialDevice] = []

    init(initialStep: Step = .initial) {
        self.currentStep = initialStep
    }

    func startSearch() {
        currentStep = .searching
    }

    func didCompleteSearch(with devices: [SerialDevice]) {
        lastDevices = devices
        currentStep = .serialDeviceSelection(devices: devices)
    }

    func selectPort(_ device: SerialDevice) {
        currentStep = .handshake(device: device)
    }

    func connectionSucceeded(device: SerialDevice) {
        currentStep = .connected(device: device)
    }

    func connectionFailed(device: SerialDevice) {
        currentStep = .failed(device: device)
    }

    /// Returns to the device list from a failed handshake, without re-scanning.
    func backToDevices() {
        currentStep = .serialDeviceSelection(devices: lastDevices)
    }

    func disconnect() {
        currentStep = .initial
    }
}
