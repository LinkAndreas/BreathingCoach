import Foundation

/// Identifies a sidebar section. Kept separate from `DetailRoute` so selection state stays
/// comparable even as routes gain associated values.
enum MenuItemID: Hashable {
    case connect
    case session
    case summary
    case history
    case settings
}
