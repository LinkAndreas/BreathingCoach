import SwiftUI

/// Shown while serial ports are being scanned.
struct ConnectProgressView: View {
    var body: some View {
        HStack(alignment: .center, spacing: 16.0) {
            ProgressCircle()
                .frame(width: 24, height: 24)
            Text("Scanning Serial Ports ...")
                .font(.body)
                .foregroundStyle(Color.bcTextSecondary)
                .fontDesign(.monospaced)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background {
            Color.bcGroupedBackground
        }
        .outline(cornerRadius: 12.0, lineWidth: 1.0, color: Color.accentColor)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    ConnectProgressView()
}
