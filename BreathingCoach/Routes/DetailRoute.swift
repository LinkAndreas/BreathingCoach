import Foundation

/// A destination in the detail column. `historyDetail` carries the id of the session to show,
/// rather than the summary itself, so the route stays `Hashable`.
enum DetailRoute: Hashable {
    case connect
    case session
    case summary
    case history
    case historyDetail(id: SessionSummary.ID)
    case settings
}
