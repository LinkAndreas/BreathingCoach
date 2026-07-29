import SwiftUI

/// One past session in the history list: when it ran, which technique, and how it went.
struct HistoryRow: View {
    let summary: SessionSummary
    let units: DisplayUnit
    let action: Action

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 10) {
                        Text(summary.date.sessionTimestamp)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(Color.bcTextPrimary)
                        Text(summary.techniqueName)
                            .font(.caption)
                            .foregroundStyle(Color.bcAccent)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(Color.bcAccent.opacity(0.12), in: Capsule())
                    }
                    Text("\(formattedDuration) · Avg \(formattedAvg) \(units.label) · \(summary.pctInTarget)% in target")
                        .font(.caption)
                        .foregroundStyle(Color.bcTextSecondary)
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
        .buttonStyle(.plain)
    }

    private var formattedDuration: String {
        summary.duration.clockString
    }

    private var formattedAvg: String {
        units.format(fromMmHg: summary.avgEtco2)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    HistoryRow(
        summary: SessionSummary(
            date: Date(),
            duration: 184,
            avgEtco2: 38,
            peakEtco2: 44,
            avgRR: 12,
            pctInTarget: 62,
            startEtco2: 28,
            endEtco2: 40,
            history: [],
            targetRange: 35...45,
            techniqueName: "CART"
        ),
        units: .mmHg,
        action: {}
    )
    .frame(width: 640)
    .padding()
    .background(Color.bcBackground)
}
