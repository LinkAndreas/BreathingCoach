import SwiftUI

/// The most recent session's summary plus its follow-up actions: train again, disconnect, or
/// browse history.
struct SessionSummaryView: View {
    let summary: SessionSummary
    let units: DisplayUnit
    let startNewSession: Action
    let disconnect: Action
    let viewHistory: Action

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SessionSummaryContentView(summary: summary, units: units)

            HStack(spacing: 16) {
                Button("Start New Session", action: startNewSession)
                    .buttonStyle(.bcFilled(color: .bcPositive))
                Button("Disconnect Device", action: disconnect)
                    .buttonStyle(.bcPlain(color: .bcTextSecondary))
                Spacer()
                Button(action: viewHistory) {
                    Text("View Session History").underline()
                }
                .buttonStyle(.plain)
                .font(.callout)
                .foregroundStyle(Color.bcTextSecondary)
            }
        }
    }
}

#Preview {
    SessionSummaryView(
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
        units: .mmHg,
        startNewSession: {},
        disconnect: {},
        viewHistory: {}
    )
    .frame(width: 760)
    .padding()
    .background(Color.bcBackground)
}
