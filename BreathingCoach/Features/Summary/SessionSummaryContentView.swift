import SwiftUI

/// The chart + stat grid + delta line shared by the Summary screen (most recent session)
/// and the History detail screen (any past session).
struct SessionSummaryContentView: View {
    let summary: SessionSummary
    let units: ConnectViewModel.DisplayUnit

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

    private var deltaText: some View {
        let deltaConverted = units.convert(fromMmHg: summary.delta)
        let deltaString = (deltaConverted >= 0 ? "+" : "") + String(format: "%.1f", deltaConverted)
        let deltaColor: Color = summary.delta >= 0 ? .bcPositive : .bcWarning

        return (
            Text("EtCO₂ moved from ")
                .foregroundStyle(Color.bcTextSecondary)
            + Text(formatted(summary.startEtco2) + " " + units.label)
                .foregroundStyle(Color.bcTextPrimary)
                .fontDesign(.monospaced)
            + Text(" to ")
                .foregroundStyle(Color.bcTextSecondary)
            + Text("\(formatted(summary.endEtco2)) \(units.label) (\(deltaString))")
                .foregroundStyle(deltaColor)
                .fontDesign(.monospaced)
        )
        .font(.callout)
    }

    private func formatted(_ mmHg: Double) -> String {
        let converted = units.convert(fromMmHg: mmHg)
        return units == .mmHg ? String(format: "%.0f", converted) : String(format: "%.1f", converted)
    }

    private var formattedDate: String {
        summary.date.formatted(date: .abbreviated, time: .shortened)
    }

    private var formattedDuration: String {
        let total = max(0, Int(summary.duration))
        return String(format: "%d:%02d", total / 60, total % 60)
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
