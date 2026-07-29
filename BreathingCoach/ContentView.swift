import NavigationKit
import SwiftUI

/// The app's root view: owns the single `ConnectViewModel` shared by every screen, builds the
/// sidebar/detail navigation shell, and presents onboarding on first launch.
struct ContentView: View {
    @State private var selection: MenuItemID = .connect
    @State private var connectViewModel = ConnectViewModel()
    @AppStorage("hasCompletedOnboarding1") private var hasCompletedOnboarding = false

    var body: some View {
        WithContext {
            let splitNavigator = SplitNavigator(
                sidebar: StackNavigator(root: SidebarRoute.menu),
                detail: StackNavigator(root: MenuItems.all[0].detailRoute),
                sidebarColumnWidth: SidebarColumnWidth(min: 250, ideal: 300, max: 375)
            )
            let routeBuilder = RouteBuilder()
            routeBuilder.register(SidebarRoute.self) { route, navigator in
                SideBarViewBuilder.build(
                    route: route,
                    navigator: navigator,
                    items: MenuItems.all,
                    selection: $selection,
                    viewModel: connectViewModel
                )
            }
            routeBuilder.register(DetailRoute.self) { route, navigator in
                DetailViewBuilder.build(
                    route: route,
                    navigator: navigator,
                    viewModel: connectViewModel,
                    goTo: { selection = $0 },
                    showOnboarding: { navigator.presentSheet(SheetRoute.onboarding) }
                )
            }
            routeBuilder.register(SheetRoute.self) { route, navigator in
                OnboardingView(
                    onFinish: {
                        hasCompletedOnboarding = true
                        navigator.dismiss()
                    },
                    onFinishWithDemo: {
                        DemoMode.shared.setEnabled(true)
                        hasCompletedOnboarding = true
                        navigator.dismiss()
                    }
                )
            }
            return (splitNavigator, routeBuilder)
        } content: { (navigator: SplitNavigator, routeBuilder: RouteBuilder) in
            NavigationContainer(
                navigator: .split(navigator),
                routeBuilder: routeBuilder
            )
            .onChange(of: selection) { oldValue, newValue in
                if let item = MenuItems.find(id: newValue) {
                    navigator.showDetail(item.detailRoute)
                }
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    ConnectionStatusPill(viewModel: connectViewModel)
                }
            }
            .task {
                if !hasCompletedOnboarding {
                    navigator.detail.presentSheet(SheetRoute.onboarding)
                }
            }
        }
        .navigationTitle("BreathingCoach")
    }
}
