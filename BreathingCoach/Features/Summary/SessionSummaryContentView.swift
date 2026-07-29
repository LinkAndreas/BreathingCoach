import SwiftUI

/// The chart + stat grid + delta line shared by the Summary screen (most recent session)
/// and the History detail screen (any past session).
struct SessionSummaryContentView: View {
    let summary: SessionSummary
    let units: DisplayUnit

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 14), count: 5)

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("\(formattedDate) · \(summary.techniqueName) · \(formattedDuration)")
                .font(.caption)
                .foregroundStyle(Color.bcTextTertiary)

            EtCO2SessionChartView(summary: summary, units: units)

            LazyVGrid(columns: columns, spacing: 14) {
                StatCardView(label: "AVG EtCO₂", value: formatted(summary.avgEtco2), unit: units.label)
                StatCardView(label: "PEAK EtCO₂", value: formatted(summary.peakEtco2), unit: units.label)
                StatCardView(label: "AVG RR", value: String(format: "%.0f", summary.avgRR), unit: "bpm")
                StatCardView(label: "TIME IN TARGET", value: "\(summary.pctInTarget)", unit: "%", valueColor: .bcPositive)
                StatCardView(label: "DURATION", value: formattedDuration, unit: "")
            }

            deltaText
        }
    }

    /// "EtCO₂ moved from X to Y (+Z)", colored by whether the session raised or lowered EtCO₂.
    private var deltaText: some View {
        let deltaString = units.formatSigned(fromMmHg: summary.delta)
        let deltaColor: Color = summary.delta >= 0 ? .bcPositive : .bcWarning

        let start = Text("\(formatted(summary.startEtco2)) \(units.label)")
            .foregroundStyle(Color.bcTextPrimary)
            .fontDesign(.monospaced)
        let end = Text("\(formatted(summary.endEtco2)) \(units.label) (\(deltaString))")
            .foregroundStyle(deltaColor)
            .fontDesign(.monospaced)

        return Text("EtCO₂ moved from \(start) to \(end)")
            .foregroundStyle(Color.bcTextSecondary)
            .font(.callout)
    }

    private func formatted(_ mmHg: Double) -> String {
        units.format(fromMmHg: mmHg)
    }

    private var formattedDate: String {
        summary.date.sessionTimestamp
    }

    private var formattedDuration: String {
        summary.duration.clockString
    }
}

#Preview {
    SessionSummaryContentView(
        summary: SessionSummary(
            date: Date(),
            duration: 184,
            avgEtco2: 38,
            peakEtco2: 44,
            avgRR: 12,
            pctInTarget: 62,
            startEtco2: 28,
            endEtco2: 40,
            history: (0..<120).map { EtCO2Sample(elapsed: Double($0), value: 28 + 12 * (Double($0) / 120)) },
            targetRange: 35...45,
            techniqueName: "CART"
        ),
        units: .mmHg
    )
    .frame(width: 760)
    .padding()
    .background(Color.bcBackground)
}
