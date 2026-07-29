import SwiftUI

/// The Connect screen's starting state, before any scan has run.
///
/// Onboarding is where demo mode is offered, but this is where someone who skipped it gets stuck,
/// so the switch lives here too — and it is the only way back out of demo mode.
struct ConnectEmptyView: View {
    let scanAction: Action
    let setDemoModeAction: ActionWithInput<Bool>

    @State private var demoMode = DemoMode.shared

    init(scanAction: @escaping Action = {}, setDemoModeAction: @escaping ActionWithInput<Bool> = { _ in }) {
        self.scanAction = scanAction
        self.setDemoModeAction = setDemoModeAction
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16.0) {
            Text("No devices scanned yet.")
                .foregroundStyle(Color.secondary)

            HStack(spacing: 12) {
                Button("Scan Devices", action: scanAction)
                    .buttonStyle(.bcFilled(color: Color.bcAccent))

                if demoMode.isEnabled {
                    Button("Leave Demo Mode", action: { setDemoModeAction(false) })
                        .buttonStyle(.bcOutline(color: Color.bcWarning))
                } else {
                    Button("Try Demo Mode", action: { setDemoModeAction(true) })
                        .buttonStyle(.bcOutline(color: Color.bcWarning))
                }
            }

            Text(
                demoMode.isEnabled
                    ? "Demo mode is on: the devices below are fake and every reading is simulated."
                    : "No capnograph? Demo mode runs the app on simulated readings so you can try it out."
            )
            .font(.caption)
            .foregroundStyle(demoMode.isEnabled ? Color.bcWarning : Color.bcTextTertiary)
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
