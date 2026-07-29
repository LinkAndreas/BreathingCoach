import SwiftUI

/// The Connect screen's starting state, before any scan has run.
struct ConnectEmptyView: View {
    let scanAction: Action

    init(scanAction: @escaping Action = {}) {
        self.scanAction = scanAction
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16.0) {
            Text("No devices scanned yet.")
                .foregroundStyle(Color.secondary)
            Button("Scan Devices", action: scanAction)
                .buttonStyle(.bcFilled(color: Color.bcAccent))
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
    ConnectEmptyView()
}
