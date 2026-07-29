import NavigationKit
import SwiftUI

@MainActor
enum DetailViewBuilder {
    @ViewBuilder
    static func build(
        route: DetailRoute,
        navigator: StackNavigator,
        viewModel: ConnectViewModel,
        goTo: @escaping (MenuItemID) -> Void,
        showOnboarding: @escaping () -> Void
    ) -> some View {
        switch route {
        case .connect:
            ConnectComposer(
                viewModel: viewModel,
                navigator: navigator,
                startBreathingSession: { goTo(.session) }
            )
        case .session:
            SessionComposer(
                viewModel: viewModel,
                navigator: navigator,
                goToConnect: { goTo(.connect) },
                goToSummary: { goTo(.summary) }
            )
        case .summary:
            SummaryComposer(
                viewModel: viewModel,
                navigator: navigator,
                startNewSession: {
                    viewModel.startSession()
                    goTo(.session)
                },
                disconnect: {
                    viewModel.disconnect()
                    goTo(.connect)
                },
                goToHistory: { goTo(.history) }
            )
        case .history:
            HistoryComposer(viewModel: viewModel, navigator: navigator)
        case .historyDetail(let id):
            if let summary = viewModel.completedSessions.first(where: { $0.id == id }) {
                HistoryDetailComposer(summary: summary, units: viewModel.units)
            }
        case .settings:
            SettingsComposer(viewModel: viewModel, navigator: navigator, showOnboarding: showOnboarding)
        }
    }
}
