import NavigationKit
import SwiftUI

struct SummaryComposer: View {
    let viewModel: ConnectViewModel
    let navigator: StackNavigator
    let startNewSession: Action
    let disconnect: Action
    let goToHistory: Action

    var body: some View {
        MenuContent(
            header: {
                MenuContentHeader(
                    title: "Session Summary",
                    subtitle: viewModel.lastSummary == nil
                        ? "No session data yet — complete a breathing session to see your summary."
                        : nil
                )
            },
            content: {
                if let summary = viewModel.lastSummary {
                    SessionSummaryView(
                        summary: summary,
                        units: viewModel.units,
                        startNewSession: startNewSession,
                        disconnect: disconnect,
                        viewHistory: goToHistory
                    )
                    .frame(maxWidth: 760, alignment: .leading)
                }
            }
        )
    }
}
