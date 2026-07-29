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
