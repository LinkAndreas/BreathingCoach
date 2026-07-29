import SwiftUI

/// Switches demo mode on or off.
///
/// Turning it off disconnects, because the connected "device" only exists while demo mode is on.
struct DemoModeSettingsCard: View {
    let viewModel: ConnectViewModel

    @State private var demoMode = DemoMode.shared

    var body: some View {
        SettingsCard(
            title: "Demo Mode",
            subtitle: "Try the app without a capnograph. Readings are simulated — never use them for anything clinical."
        ) {
            VStack(alignment: .leading, spacing: 10) {
                Toggle("Use simulated readings", isOn: binding)
                    .toggleStyle(.switch)
                    .tint(Color.bcWarning)

                if demoMode.isEnabled {
                    Text("Demo mode is on. Every value in the app is generated, and the window shows a DEMO DATA badge.")
                        .font(.caption)
                        .foregroundStyle(Color.bcWarning)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }

    private var binding: Binding<Bool> {
        Binding(
            get: { demoMode.isEnabled },
            set: { isEnabled in
                // The connection belongs to whichever mode created it, so end it either way.
                if viewModel.isConnected {
                    viewModel.disconnect()
                }
                demoMode.setEnabled(isEnabled)
            }
        )
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    DemoModeSettingsCard(viewModel: ConnectViewModel())
        .frame(width: 480)
        .padding()
        .background(Color.bcBackground)
}
