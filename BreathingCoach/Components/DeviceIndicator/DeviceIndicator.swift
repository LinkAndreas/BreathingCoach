import SwiftUI

struct DeviceIndicator: View {
    let deviceName: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Device")
                .fontDesign(.monospaced)
                .fontWeight(.semibold)
            Group {
                if let deviceName {
                    Text(deviceName)
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
