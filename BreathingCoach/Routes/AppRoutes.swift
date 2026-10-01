import NavigationKit
import SwiftUI

/// Maps each route to its screen, wiring every screen to the shared view model and to the
/// cross-section navigation (e.g. Summary's "start another session" jumps to Session).
struct AppRoutes: RouteModule {
    let viewModel: ConnectViewModel
    let completeOnboarding: Action

    func register(in registry: RouteRegistry) {
        registry.register { (route: DetailRoute, nav) in
            switch route {
            case .connect:
                ConnectComposer(
                    viewModel: viewModel,
                    startBreathingSession: { nav.select(MenuItemID.session) }
                )
            case .session:
                SessionComposer(
                    viewModel: viewModel,
                    goToConnect: { nav.select(MenuItemID.connect) },
                    goToSummary: { nav.select(MenuItemID.summary) }
                )
            case .summary:
                SummaryComposer(
                    viewModel: viewModel,
                    startNewSession: {
                        viewModel.startSession()
                        nav.select(MenuItemID.session)
                    },
                    disconnect: {
                        viewModel.disconnect()
                        nav.select(MenuItemID.connect)
                    },
                    goToHistory: { nav.select(MenuItemID.history) }
                )
            case .history:
                HistoryComposer(
                    viewModel: viewModel,
                    openSession: { nav.push(.historyDetail(id: $0)) }
                )
            case .historyDetail(let id):
                if let summary = viewModel.completedSessions.first(where: { $0.id == id }) {
                    HistoryDetailComposer(summary: summary, units: viewModel.units)
                }
            case .settings:
                SettingsComposer(
                    viewModel: viewModel,
                    showOnboarding: { nav.present(SheetRoute.onboarding) }
                )
            }
        }

        registry.register { (_: SheetRoute, nav) in
            OnboardingView(
                onFinish: {
                    completeOnboarding()
                    nav.dismiss()
                },
                onFinishWithDemo: {
                    DemoMode.shared.setEnabled(true)
                    completeOnboarding()
                    nav.dismiss()
                }
            )
        }
    }
}
