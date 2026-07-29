import SwiftUI

/// Adjusts the EtCO₂ target range. Always in mmHg regardless of display unit, since the clinical
/// reference values users are given are quoted in mmHg.
struct TargetRangeSettingsCard: View {
    let viewModel: ConnectViewModel

    var body: some View {
        SettingsCard(
            title: "Target EtCO₂ Range",
            subtitle: "Typical adult normal range is 35–45 mmHg. Consult your clinician before changing."
        ) {
            VStack(spacing: 12) {
                sliderRow(
                    label: "Min",
                    value: viewModel.targetRange.lowerBound,
                    range: 20...45,
                    onChange: viewModel.setTargetMin
                )
                sliderRow(
                    label: "Max",
                    value: viewModel.targetRange.upperBound,
                    range: 35...60,
                    onChange: viewModel.setTargetMax
                )
            }
        }
    }

    @ViewBuilder
    private func sliderRow(
        label: LocalizedStringKey,
        value: Double,
        range: ClosedRange<Double>,
        onChange: @escaping (Double) -> Void
    ) -> some View {
        HStack(spacing: 12) {
            Text(label)
                .font(.caption)
                .foregroundStyle(Color.bcTextSecondary)
                .frame(width: 36, alignment: .leading)
            Slider(value: Binding(get: { value }, set: onChange), in: range, step: 1)
                .tint(Color.bcAccent)
            Text("\(Int(value)) mmHg")
                .font(.caption.monospaced())
                .foregroundStyle(Color.bcTextPrimary)
                .frame(width: 64, alignment: .trailing)
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    TargetRangeSettingsCard(viewModel: ConnectViewModel())
        .frame(width: 480)
        .padding()
        .background(Color.bcBackground)
}
