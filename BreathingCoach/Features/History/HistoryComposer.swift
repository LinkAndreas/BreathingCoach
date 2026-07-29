import NavigationKit
import SwiftUI

struct HistoryComposer: View {
    let viewModel: ConnectViewModel
    let navigator: StackNavigator

    var body: some View {
        MenuContent(
            header: {
                MenuContentHeader(
                    title: "Session History",
                    subtitle: viewModel.completedSessions.isEmpty
                        ? "No completed sessions yet. Finish a breathing session to see it here."
                        : nil
                )
            },
            content: {
                if !viewModel.completedSessions.isEmpty {
                    VStack(spacing: 10) {
                        ForEach(viewModel.completedSessions.reversed()) { summary in
                            HistoryRow(
                                summary: summary,
                                units: viewModel.units,
                                action: { navigator.push(DetailRoute.historyDetail(id: summary.id)) }
                            )
                        }
                    }
                    .frame(maxWidth: 640, alignment: .leading)
                }
            }
        )
    }
}
