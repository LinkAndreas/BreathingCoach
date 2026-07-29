import SwiftUI

/// Shown once a monitor is connected: device details, plus starting a session or disconnecting.
struct ConnectSuccessfulConnectionView: View {
    let device: SerialDevice
    let startBreathingSessionAction: Action
    let disconnectAction: Action

    init(
        device: SerialDevice,
        startBreathingSessionAction: @escaping Action = {},
        disconnectAction: @escaping Action = {}
    ) {
        self.device = device
        self.startBreathingSessionAction = startBreathingSessionAction
        self.disconnectAction = disconnectAction
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16.0) {
            ConnectionStatusView(status: .succeeded)
            GridInfoView(items: [
                GridInfoView.Item(
                    title: "Device ID",
                    value: device.name
                ),
                GridInfoView.Item(
                    title: "Path",
                    value: device.path
                ),
                GridInfoView.Item(
                    title: "Baud",
                    value: "\(device.baudRate)"
                ),
                GridInfoView.Item(
                    title: "Protocol",
                    value: device.communicationProtocol
                )
            ])
            HStack(spacing: 16.0) {
                Button("Start Breathing Session", action: startBreathingSessionAction)
                    .buttonStyle(.bcFilled(color: .bcPositive))
                Button("Disconnect", action: disconnectAction)
                    .buttonStyle(.bcPlain(color: .bcTextSecondary))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background {
            Color.bcGroupedBackground
        }
        .outline(cornerRadius: 12.0, lineWidth: 1.0, color: Color.bcPositive)
    }
}

#Preview {
    ConnectSuccessfulConnectionView(
        device: SerialDevice(
            name: "CAPNOSTREAM20 SW v02.14.00",
            path: "/dev/cu.usbserial-A5069RR4",
            baudRate: 9600,
            communicationProtocol: "Oridion/Medtronic Host Protocol v2",
            connectionStatus: .available
        )
    )
    .frame(width: 600)
    .padding()
}
