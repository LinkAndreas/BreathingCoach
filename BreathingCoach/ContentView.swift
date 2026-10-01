import NavigationKit
import SwiftUI

/// The app's root view: owns the single `ConnectViewModel` shared by every screen, builds the
/// sidebar/detail navigation shell, and presents onboarding on first launch.
struct ContentView: View {
    @State private var connectViewModel = ConnectViewModel()
    @State private var store = NavigationStore(
        layout: .split,
        selection: MenuItemID.connect,
        sections: MenuItems.all.map { item in
            RootSection(item.id, item.title) { item.detailRoute }
        }
    )
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    var body: some View {
        NavigationRoot(store: store, selection: MenuItemID.connect) { selection in
            SideBarView(items: MenuItems.all, selection: selection, viewModel: connectViewModel)
        }
        .routes(AppRoutes(
            viewModel: connectViewModel,
            completeOnboarding: { hasCompletedOnboarding = true }
        ))
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                ConnectionStatusPill(viewModel: connectViewModel)
            }
        }
        .task {
            if !hasCompletedOnboarding {
                store.navigator.present(SheetRoute.onboarding)
            }
        }
        .navigationTitle("BreathingCoach")
    }
}
