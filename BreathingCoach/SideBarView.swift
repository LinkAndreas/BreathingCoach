import SwiftUI

/// The sidebar column: the section menu plus a pinned indicator showing which device, if any,
/// is currently connected.
struct SideBarView: View {
    let items: [MenuItem<MenuItemID>]
    @Binding var selection: MenuItemID
    let viewModel: ConnectViewModel

    var body: some View {
        Menu<MenuItemID>(
            sectionTitle: "BreathingCoach",
            items: items,
            selection: $selection
        )
        .navigationSplitViewColumnWidth(min: 250, ideal: 300, max: 375)
        .overlay(alignment: .bottom) {
            DeviceIndicator(deviceName: viewModel.connectedDevice?.name)
                .padding()
        }
    }
}
