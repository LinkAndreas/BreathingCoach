import SwiftUI

/// The breathing pacer — the most prominent widget on the Live Session screen.
/// Purely about pacing rhythm; EtCO₂ readout and target feedback live in `EtCO2CardView`.
struct BreathingAssistantCardView: View {
    let phase: BreathingPhase
    let scale: Double
    let caption: String

    var body: some View {
        VStack(spacing: 22) {
            ZStack {
                Circle()
                    .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [6, 5]))
                    .foregroundStyle(Color.bcPositive.opacity(0.35))
                    .frame(width: 340, height: 340)

                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [Color.bcAccent.opacity(0.4), Color.bcAccent.opacity(0.14)],
                                center: .center,
                                startRadius: 0,
                                endRadius: 140
                            )
                        )
                        .overlay(Circle().strokeBorder(Color.bcAccent, lineWidth: 2))
                        .shadow(color: Color.bcAccent.opacity(0.25), radius: 70)

                    Text(phase.label)
                        .font(.system(size: 40, weight: .bold))
                        .foregroundStyle(Color.bcTextPrimary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .padding(.horizontal, 24)
                }
                .frame(width: 280, height: 280)
                .scaleEffect(scale)
            }
            .frame(width: 340, height: 340)

            Text(caption)
                .font(.callout)
                .foregroundStyle(Color.bcTextSecondary)
        }
        .padding(32)
        .frame(maxWidth: .infinity)
        .background(Color.bcSecondaryBackground, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .outline(cornerRadius: 16, lineWidth: 1, color: Color.bcAccent.opacity(0.3))
    }
}

#Preview {
    BreathingAssistantCardView(phase: .inhale, scale: 0.85, caption: "CART · 6.0 breaths/min")
        .padding()
        .background(Color.bcBackground)
}
