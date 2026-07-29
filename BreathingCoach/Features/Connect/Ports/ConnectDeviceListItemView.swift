import SwiftUI

struct ConnectDeviceListItemView: View {
    struct AccessoryView: View {
        enum Accessory {
            case unsupported
            case connectButton(action: () -> Void)
        }

        let accessory: Accessory?
        
        var body: some View {
            switch accessory {
                case .unsupported:
                Text("Unsupported")
                    .font(.caption)
                    .foregroundStyle(Color.bcTextDisabled)
            case .connectButton(let action):
                Button("Connect", action: action)
                    .buttonStyle(.bcOutline(color: Color.bcPositive))
            case .none:
                EmptyView()
            }
        }
    }

    let title: String
    let subtitle: String
    let accessory: AccessoryView.Accessory?

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                    .fontDesign(.monospaced)
                    .foregroundStyle(Color.bcTextPrimary)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(Color.bcTextSecondary)
            }
            Spacer()
            
            AccessoryView(accessory: accessory)
        }
        .padding(16)
        .background {
            Color.bcSecondaryGroupedBackground
                .cornerRadius(12.0)
        }
        .outline(
            cornerRadius: 12.0,
            lineWidth: 1.0,
            color: Color.bcBorder
        )
    }
}

#Preview {
    VStack {
        ConnectDeviceListItemView(
            title: "/dev/cu.usbserial-A5069RR4",
            subtitle: "Capnostream 20p",
            accessory: .connectButton(action: {})
        )
        ConnectDeviceListItemView(
            title: "/dev/cu.usbserial-A5069RR7",
            subtitle: "Capnostream 20p",
            accessory: .unsupported
        )
    }
    .padding()
}
