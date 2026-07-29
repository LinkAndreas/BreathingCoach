import SwiftUI

struct BreathingTechniqueGuideView: View {
    let technique: BreathingTechnique
    var customPaceBreathsPerMinute: Double = 6
    var onClose: Action?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(technique.name)
                        .font(.title.weight(.bold))
                        .foregroundStyle(Color.bcTextPrimary)
                    Text(technique.subtitle)
                        .font(.callout)
                        .foregroundStyle(Color.bcTextTertiary)
                }

                section(title: "Pattern") {
                    VStack(alignment: .leading, spacing: 10) {
                        SegmentTimingRow(segments: technique.segments(customBreathsPerMinute: customPaceBreathsPerMinute))
                        if technique.segments(customBreathsPerMinute: customPaceBreathsPerMinute).cycleDuration > 0 {
                            Text("\(String(format: "%.1f", technique.breathsPerMinute(customBreathsPerMinute: customPaceBreathsPerMinute))) breaths/min")
                                .font(.caption)
                                .foregroundStyle(Color.bcTextTertiary)
                        }
                        if technique.id == "custom" {
                            Text("Based on your current pace setting in Settings.")
                                .font(.caption)
                                .foregroundStyle(Color.bcTextTertiary)
                        }
                    }
                }

                section(title: "About") {
                    Text(technique.description)
                        .font(.body)
                        .foregroundStyle(Color.bcTextSecondary)
                }

                section(title: "Benefits") {
                    Text(technique.benefits)
                        .font(.body)
                        .foregroundStyle(Color.bcTextSecondary)
                }

                section(title: "How to Practice") {
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(Array(technique.steps.enumerated()), id: \.offset) { index, step in
                            HStack(alignment: .top, spacing: 12) {
                                Text("\(index + 1)")
                                    .font(.caption.weight(.bold))
                                    .foregroundStyle(Color.bcFilledButtonText)
                                    .frame(width: 20, height: 20)
                                    .background(Color.bcAccent, in: Circle())
                                Text(step)
                                    .font(.body)
                                    .foregroundStyle(Color.bcTextSecondary)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 28)
            .padding(.top, 24)
            .padding(.bottom, 36)
            .frame(maxWidth: 560, alignment: .leading)
        }
        .background {
            Color.bcBackground
                .ignoresSafeArea()
        }
        .overlay(alignment: .topTrailing) {
            if let onClose {
                ModalCloseButton(action: onClose)
                    .padding(16)
            }
        }
    }

    @ViewBuilder
    private func section<Content: View>(title: LocalizedStringKey, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption.weight(.semibold))
                .tracking(0.6)
                .foregroundStyle(Color.bcTextTertiary)
            content()
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.bcSecondaryBackground, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        .outline(cornerRadius: 12, lineWidth: 1, color: Color.bcBorder)
    }
}

#Preview {
    BreathingTechniqueGuideView(technique: .all[4])
//        .frame(width: 640, height: 700)
}
