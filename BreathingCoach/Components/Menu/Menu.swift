import SwiftUI

/// The sidebar's scrollable list of sections, with a title above and a selection binding that the
/// navigation shell observes to swap the detail column.
struct Menu<MenuItemID: Hashable>: View {
    private let sectionTitle: LocalizedStringKey
    private let items: [MenuItem<MenuItemID>]
    @Binding private var selection: MenuItemID

    init(sectionTitle: LocalizedStringKey, items: [MenuItem<MenuItemID>], selection: Binding<MenuItemID>) {
        self.sectionTitle = sectionTitle
        self.items = items
        self._selection = selection
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                Text(sectionTitle)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 8.0)
                Spacer()
                    .frame(height: 12.0)
                ForEach(items, id: \.id) { item in
                    MenuItemView(
                        title: item.title,
                        isSelected: selection == item.id,
                        onTap: { selection = item.id }
                    )
                }
            }
        }
        .contentMargins(.all, 12.0)
        .background(Color.bcSidebarBackground)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    @Previewable @State var selection: MenuItemID? = .connect
    Menu(
        sectionTitle: "BreathingCoach",
        items: [
            MenuItem(id: .connect, title: "Connect", detailRoute: .connect),
            MenuItem(id: .session, title: "Session", detailRoute: .session),
            MenuItem(id: .summary, title: "Summary", detailRoute: .summary),
            MenuItem(id: .settings, title: "Settings", detailRoute: .settings)
        ],
        selection: $selection
    )
}
