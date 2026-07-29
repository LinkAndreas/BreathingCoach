import SwiftUI

/// Renders exactly one of the connect steps. Taking each step as a separate view builder keeps
/// the step views free of routing logic and makes them previewable in isolation.
struct ConnectFlow<
    Initial: View,
    Searching: View,
    SerialDeviceSelection: View,
    Handshake: View,
    Connected: View,
    Failed: View
>: View {
    private let currentStep: ConnectRouter.Step
    private let initial: () -> Initial
    private let searching: () -> Searching
    private let serialDeviceSelection: ([SerialDevice]) -> SerialDeviceSelection
    private let handshake: (SerialDevice) -> Handshake
    private let connected: (SerialDevice) -> Connected
    private let failed: (SerialDevice) -> Failed

    init(
        currentStep: ConnectRouter.Step,
        @ViewBuilder initial: @escaping () -> Initial,
        @ViewBuilder searching: @escaping () -> Searching,
        @ViewBuilder serialDeviceSelection: @escaping ([SerialDevice]) -> SerialDeviceSelection,
        @ViewBuilder handshake: @escaping (SerialDevice) -> Handshake,
        @ViewBuilder connected: @escaping (SerialDevice) -> Connected,
        @ViewBuilder failed: @escaping (SerialDevice) -> Failed
    ) {
        self.currentStep = currentStep
        self.initial = initial
        self.searching = searching
        self.serialDeviceSelection = serialDeviceSelection
        self.handshake = handshake
        self.connected = connected
        self.failed = failed
    }

    var body: some View {
        switch currentStep {
        case .initial:
            initial()
        case .searching:
            searching()
        case let .serialDeviceSelection(devices):
            serialDeviceSelection(devices)
        case let .handshake(port):
            handshake(port)
        case let .connected(port):
            connected(port)
        case let .failed(port):
            failed(port)
        }
    }
}
