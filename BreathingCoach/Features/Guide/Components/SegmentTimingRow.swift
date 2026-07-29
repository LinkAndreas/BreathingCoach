import SwiftUI

/// A row of chips summarizing a technique's inhale/hold/exhale/hold timing.
struct SegmentTimingRow: View {
    let segments: BreathingTechnique.Segments

    var body: some View {
        HStack(spacing: 10) {
            chip(label: "Inhale", seconds: segments.inhale, color: .bcAccent)
            if segments.holdIn > 0 {
                chip(label: "Hold", seconds: segments.holdIn, color: .bcTextTertiary)
            }
            chip(label: "Exhale", seconds: segments.exhale, color: .bcPositive)
            if segments.holdOut > 0 {
                chip(label: "Hold", seconds: segments.holdOut, color: .bcTextTertiary)
            }
        }
    }

    @ViewBuilder
    private func chip(label: LocalizedStringKey, seconds: TimeInterval, color: Color) -> some View {
        VStack(spacing: 2) {
            Text("\(Int(seconds))s")
                .font(.system(.callout, design: .monospaced).weight(.semibold))
                .foregroundStyle(color)
            Text(label)
                .font(.caption)
                .foregroundStyle(Color.bcTextTertiary)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .frame(minWidth: 64)
        .background(Color.bcChipBackground, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    SegmentTimingRow(segments: BreathingTechnique.Segments(inhale: 4, holdIn: 7, exhale: 8, holdOut: 0))
        .padding()
        .background(Color.bcBackground)
}
