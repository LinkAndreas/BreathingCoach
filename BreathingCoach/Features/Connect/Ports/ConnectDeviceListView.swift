import SwiftUI

struct ConnectDeviceListView: View {
    private let devices: [SerialDevice]
    private let connectAction: ActionWithInput<SerialDevice>
    
    init(
        devices: [SerialDevice] = [],
        connectAction: @escaping ActionWithInput<SerialDevice> = { _ in }
    ) {
        self.devices = devices
        self.connectAction = connectAction
    }

    var body: some View {
        ScrollViewIfNeeded {
            VStack(alignment: .leading) {
                ForEach(devices) { device in
                    ConnectDeviceListItemView(
                        title: device.path,
                        subtitle: device.name + "⋅" + "\(device.baudRate)" + " " + "baud",
                        accessory: device.accessory {
                            connectAction(device)
                        }
                    )
                }
            }
        }
    }
}

extension SerialDevice {
    func accessory(connect: @escaping Action) -> ConnectDeviceListItemView.AccessoryView.Accessory? {
        switch connectionStatus {
        case .available:
            .connectButton(action: connect)
        case .unavailable:
            nil
        case .unknown:
            .unsupported
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    ConnectDeviceListView(
        devices: [
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
                communicationProtocol: "Unkown",
                connectionStatus: .unknown
            )
        ]
    )
    .padding()
}
