import Foundation
import NavigationKit
import SwiftUI

enum MenuItems {
    static let all: [MenuItem<MenuItemID>] = [
        MenuItem(
            id: .connect,
            title: "Connect",
            detailRoute: .connect
        ),
        MenuItem(
            id: .session,
            title: "Session",
            detailRoute: .session
        ),
        MenuItem(
            id: .summary,
            title: "Summary",
            detailRoute: .summary
        ),
        MenuItem(
            id: .history,
            title: "History",
            detailRoute: .history
        ),
        MenuItem(
            id: .settings,
            title: "Settings",
            detailRoute: .settings
        )
    ]
    
    static func find(id: MenuItemID) -> MenuItem<MenuItemID>? {
        all.first(where: { $0.id == id })
    }
}
