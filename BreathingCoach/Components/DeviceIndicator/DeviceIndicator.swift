import SwiftUI

/// Pinned to the bottom of the sidebar: names the connected monitor, or states that none is
/// connected, so the connection is visible from every screen.
struct DeviceIndicator: View {
    let deviceName: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Device")
                .fontDesign(.monospaced)
                .fontWeight(.semibold)
            Group {
                if let deviceName {
                    // Model names are longer than the sidebar is wide and have no useful break
                    // point, so let the text shrink to fit rather than split "Capnostream" in two.
                    Text(deviceName)
                        .lineLimit(2)
                        .minimumScaleFactor(0.7)
                        .help(deviceName)
                } else {
                    Text("No device connected")
                }
            }
            .fontDesign(.monospaced)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(Material.thin)
                .strokeBorder(.blue, lineWidth: 1)
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    DeviceIndicator(deviceName: "CAPNOSTREAM20 SW v02.14.00")
}
