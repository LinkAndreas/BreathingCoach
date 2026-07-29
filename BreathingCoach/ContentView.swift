import NavigationKit
import SwiftUI

struct ContentView: View {
    @State private var selection: MenuItemID = .connect
    @State private var connectViewModel = ConnectViewModel()
    @State private var isOnboardingPresented = false
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    var body: some View {
        WithContext {
            let splitNavigator = SplitNavigator(
                sidebar: StackNavigator(root: SidebarRoute.menu),
                detail: StackNavigator(root: MenuItems.all[0].detailRoute)
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
                    showOnboarding: { isOnboardingPresented = true }
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
        }
        .navigationTitle("Biofeedback Training")
        .task {
            if !hasCompletedOnboarding {
                isOnboardingPresented = true
            }
        }
        .sheet(isPresented: $isOnboardingPresented) {
            OnboardingView(onFinish: {
                hasCompletedOnboarding = true
                isOnboardingPresented = false
            })
        }
    }
}
