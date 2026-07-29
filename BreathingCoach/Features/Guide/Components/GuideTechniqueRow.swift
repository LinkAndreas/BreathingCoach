import SwiftUI

/// Visual content for a technique row in the guide list. Tap handling is owned by
/// whatever wraps this (a `NavigationLink` in `BreathingGuideListView`).
struct GuideTechniqueRow: View {
    let technique: BreathingTechnique

    var body: some View {
        HStack(spacing: 14) {
            VStack(alignment: .leading, spacing: 4) {
                Text(technique.name)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Color.bcTextPrimary)
                Text(technique.subtitle)
                    .font(.caption)
                    .foregroundStyle(Color.bcTextTertiary)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption.weight(.semibold))
                .foregroundStyle(Color.bcTextTertiary)
        }
        .padding(14)
        .background(Color.bcSecondaryBackground, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
        .outline(cornerRadius: 10, lineWidth: 1, color: Color.bcBorder)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    GuideTechniqueRow(technique: .all[0])
        .frame(width: 480)
        .padding()
        .background(Color.bcBackground)
}
