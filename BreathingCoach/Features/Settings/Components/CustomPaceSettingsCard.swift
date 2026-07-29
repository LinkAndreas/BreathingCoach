import SwiftUI

/// Sets the breathing rate used by the Custom Pace technique.
struct CustomPaceSettingsCard: View {
    let viewModel: ConnectViewModel

    var body: some View {
        SettingsCard(
            title: "Custom Pace",
            subtitle: "Used only when the \"Custom Pace\" technique is selected on the Live Session screen. Ratio 40% inhale / 60% exhale."
        ) {
            HStack(spacing: 12) {
                Slider(
                    value: Binding(get: { viewModel.customPaceBreathsPerMinute }, set: viewModel.setCustomPace),
                    in: 4...8,
                    step: 0.5
                )
                .tint(Color.bcAccent)
                Text("\(paceValueText) breaths/min")
                    .font(.caption.monospaced())
                    .foregroundStyle(Color.bcTextPrimary)
                    .frame(width: 120, alignment: .trailing)
            }
        }
    }

    private var paceValueText: String {
        String(format: "%.1f", viewModel.customPaceBreathsPerMinute)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    CustomPaceSettingsCard(viewModel: ConnectViewModel())
        .frame(width: 480)
        .padding()
        .background(Color.bcBackground)
}
