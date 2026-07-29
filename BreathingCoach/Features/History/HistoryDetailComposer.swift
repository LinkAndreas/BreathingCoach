import SwiftUI

/// A past session, shown with the same layout as the Summary screen.
struct HistoryDetailComposer: View {
    let summary: SessionSummary
    let units: DisplayUnit

    var body: some View {
        MenuContent(
            header: {
                VStack(alignment: .leading, spacing: 8.0) {
                    Text(summary.date.sessionTimestamp)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(summary.techniqueName)
                        .font(.body)
                        .foregroundStyle(Color.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            },
            content: {
                SessionSummaryContentView(summary: summary, units: units)
                    .frame(maxWidth: 760, alignment: .leading)
            }
        )
    }
}
