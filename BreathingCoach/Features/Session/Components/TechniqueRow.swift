import SwiftUI

/// A selectable technique in the picker, showing its pace and one-line description.
struct TechniqueRow: View {
    let technique: BreathingTechnique
    let isSelected: Bool
    let breathsPerMinute: Double
    let action: Action
    let showGuide: Action

    private var tintColor: Color { isSelected ? .bcAccent : .bcTextDisabled }

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Button(action: action) {
                HStack(alignment: .top, spacing: 14) {
                    ZStack {
                        Circle()
                            .strokeBorder(tintColor, lineWidth: 2)
                            .frame(width: 16, height: 16)
                        if isSelected {
                            Circle()
                                .fill(tintColor)
                                .frame(width: 8, height: 8)
                        }
                    }
                    .padding(.top, 2)

                    VStack(alignment: .leading, spacing: 4) {
                        HStack(alignment: .firstTextBaseline, spacing: 10) {
                            Text(technique.name)
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(Color.bcTextPrimary)
                            Text(technique.subtitle)
                                .font(.caption)
                                .foregroundStyle(Color.bcTextTertiary)
                            Spacer()
                            Text("\(breathsPerMinute, format: .number.precision(.fractionLength(1)))/min")
                                .font(.caption.monospaced())
                                .foregroundStyle(Color.bcAccent)
                        }
                        Text(technique.description)
                            .font(.caption)
                            .foregroundStyle(Color.bcTextSecondary)
                    }
                }
            }
            .buttonStyle(.plain)

            Button(action: showGuide) {
                Image(systemName: "info.circle")
                    .font(.body)
                    .foregroundStyle(Color.bcTextTertiary)
            }
            .buttonStyle(.plain)
            .padding(.top, 2)
        }
        .padding(14)
        .background(Color.bcSecondaryBackground, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
        .outline(
            cornerRadius: 10,
            lineWidth: 1,
            color: isSelected ? Color.bcAccent.opacity(0.6) : Color.bcBorder
        )
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    VStack(spacing: 10) {
        ForEach(BreathingTechnique.all) { technique in
            TechniqueRow(
                technique: technique,
                isSelected: technique.id == "cart",
                breathsPerMinute: technique.breathsPerMinute(customBreathsPerMinute: 6),
                action: {},
                showGuide: {}
            )
        }
    }
    .padding()
    .frame(width: 640)
    .background(Color.bcBackground)
}
