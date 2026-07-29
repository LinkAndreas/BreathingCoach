import SwiftUI

struct UnitsSettingsCard: View {
    let viewModel: ConnectViewModel

    var body: some View {
        SettingsCard(title: "Units") {
            HStack(spacing: 3) {
                ForEach(ConnectViewModel.DisplayUnit.allCases, id: \.self) { unit in
                    let isSelected = viewModel.units == unit
                    Button(unit.label, action: { viewModel.setUnits(unit) })
                        .buttonStyle(.plain)
                        .font(.caption.weight(.semibold))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 7)
                        .background(
                            isSelected ? Color.bcAccent : Color.clear,
                            in: RoundedRectangle(cornerRadius: 6, style: .continuous)
                        )
                        .foregroundStyle(isSelected ? Color.bcFilledButtonText : Color.bcTextSecondary)
                }
            }
            .padding(3)
            .background(Color.bcTrackBackground, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    UnitsSettingsCard(viewModel: ConnectViewModel())
        .frame(width: 480)
        .padding()
        .background(Color.bcBackground)
}
