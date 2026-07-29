import SwiftUI

/// Small "Connected / Connecting… / Disconnected" indicator shown in the window toolbar,
/// mirroring the status pill from the design.
struct ConnectionStatusPill: View {
    let viewModel: ConnectViewModel

    private var label: LocalizedStringKey {
        if viewModel.isConnected { "Connected" }
        else if viewModel.isConnecting { "Connecting…" }
        else { "Disconnected" }
    }

    private var color: Color {
        if viewModel.isConnected { .bcPositive }
        else if viewModel.isConnecting { .bcWarning }
        else { .bcTextTertiary }
    }

    var body: some View {
        HStack(spacing: 8) {
            if DemoMode.shared.isEnabled {
                demoBadge
            }

            HStack(spacing: 6) {
                Circle()
                    .fill(color)
                    .frame(width: 7, height: 7)
                Text(label)
                    .font(.system(size: 11, design: .monospaced))
                    .foregroundStyle(color)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(Color.bcChipBackground, in: Capsule())
        }
    }

    /// Marks the whole window as showing simulated readings. Deliberately loud: a value the user
    /// cannot tell apart from a real measurement is the one thing this app must never show.
    private var demoBadge: some View {
        Text("DEMO DATA")
            .font(.system(size: 11, weight: .bold, design: .monospaced))
            .foregroundStyle(Color.bcWarning)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(Color.bcWarning.opacity(0.15), in: Capsule())
            .help("Readings are simulated. This launch is running in demo mode.")
    }
}
