import SwiftUI

/// The result of a scan: every discovered device, with the option to scan again.
struct ConnectDevicesOverview: View {
    let devices: [SerialDevice]
    let connectAction: ActionWithInput<SerialDevice>
    let rescanAction: Action

    init(
        devices: [SerialDevice],
        connectAction: @escaping ActionWithInput<SerialDevice> = { _ in },
        rescanAction: @escaping Action = {}
    ) {
        self.devices = devices
        self.connectAction = connectAction
        self.rescanAction = rescanAction
    }

    var body: some View {
        VStack(alignment: .leading) {
            if devices.isEmpty {
                ContentUnavailableView(
                    "No Serial devices",
                    systemImage: "cable.connector.slashed",
                    description: Text("No Serial devices have been found.")
                )
            } else {
                VStack(alignment: .leading, spacing: 8.0) {
                    Group {
                        if devices.count == 1 {
                            Text("1 Serial Device Found")
                        } else {
                            Text("\(devices.count) Serial Devices Found")
                        }
                    }
                    .font(.body)
                    .fontDesign(.monospaced)
                    .fontWeight(.thin)
                    ConnectDeviceListView(devices: devices, connectAction: connectAction)
                    Button("Rescan", action: rescanAction)
                        .buttonStyle(.plain)
                        .foregroundStyle(Color.bcAccent)
                }
            }
        }
        .padding()
        .background {
            Color.bcGroupedBackground
        }
        .outline(cornerRadius: 12.0, lineWidth: 1.0, color: Color.accentColor)
    }
}

#Preview {
    ConnectDevicesOverview(devices: [
        SerialDevice(
            name: "Capnostream 20p",
            path: "/dev/cu.usbserial-A5069RR4",
            baudRate: 9600,
            communicationProtocol: "Oridion/Medtronic Host Protocol v2",
            connectionStatus: .available
        ),
        SerialDevice(
            name: "Capnostream 20p",
            path: "/dev/cu.usbserial-A5069RR4",
            baudRate: 9600,
            communicationProtocol: "Oridion/Medtronic Host Protocol v2",
            connectionStatus: .available
        ),
        SerialDevice(
            name: "Unknown device",
            path: "/dev/cu.Bluetooth-Incoming-Port",
            baudRate: 9600,
            communicationProtocol: "Unknown",
            connectionStatus: .unknown
        )
    ])
    .padding()
}
