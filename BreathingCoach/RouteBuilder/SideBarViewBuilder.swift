import NavigationKit
import SwiftUI

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
