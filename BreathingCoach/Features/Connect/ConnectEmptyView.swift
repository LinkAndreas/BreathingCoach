import SwiftUI

/// The Connect screen's starting state, before any scan has run.
///
/// This is where someone without a capnograph gets stuck, so it also offers demo mode — the one
/// place in the app where that offer is genuinely useful.
struct ConnectEmptyView: View {
    let scanAction: Action
    let startDemoAction: Action

    @State private var demoMode = DemoMode.shared

    init(scanAction: @escaping Action = {}, startDemoAction: @escaping Action = {}) {
        self.scanAction = scanAction
        self.startDemoAction = startDemoAction
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16.0) {
            Text("No devices scanned yet.")
                .foregroundStyle(Color.secondary)

            HStack(spacing: 12) {
                Button("Scan Devices", action: scanAction)
                    .buttonStyle(.bcFilled(color: Color.bcAccent))

                if !demoMode.isEnabled {
                    Button("Try Demo Mode", action: startDemoAction)
                        .buttonStyle(.bcOutline(color: Color.bcWarning))
                }
            }

            if !demoMode.isEnabled {
                Text("No capnograph? Demo mode runs the app on simulated readings so you can try it out.")
                    .font(.caption)
                    .foregroundStyle(Color.bcTextTertiary)
            }
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
