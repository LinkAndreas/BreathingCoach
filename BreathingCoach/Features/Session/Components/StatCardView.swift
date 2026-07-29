import SwiftUI

struct StatCardView: View {
    let label: LocalizedStringKey
    let value: String
    let unit: String
    var valueColor: Color = .bcTextPrimary

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.caption.weight(.semibold))
                .tracking(0.6)
                .foregroundStyle(Color.bcTextTertiary)
            Text(value)
                .font(.system(size: 28, weight: .bold, design: .monospaced))
                .foregroundStyle(valueColor)
                .contentTransition(.numericText())
                .animation(.default, value: value)
            Text(unit)
                .font(.caption)
                .foregroundStyle(Color.bcTextTertiary)
        }
        .padding(14)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background(Color.bcSecondaryBackground, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        .outline(cornerRadius: 12, lineWidth: 1, color: Color.bcBorder)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    HStack {
        StatCardView(label: "RR", value: "17", unit: "bpm")
        StatCardView(label: "SpO₂", value: "98", unit: "%")
    }
    .frame(width: 220)
    .padding()
    .background(Color.bcBackground)
}
