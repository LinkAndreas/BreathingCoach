import NavigationKit
import SwiftUI

/// Builds the sidebar-column view for a route.
@MainActor
enum SideBarViewBuilder {
    @ViewBuilder
    static func build(
        route: SidebarRoute,
        navigator: StackNavigator,
        items: [MenuItem<MenuItemID>],
        selection: Binding<MenuItemID>,
        viewModel: ConnectViewModel
    ) -> some View {
        switch route {
        case .menu:
            SideBarView(items: items, selection: selection, viewModel: viewModel)
        }
    }
}
