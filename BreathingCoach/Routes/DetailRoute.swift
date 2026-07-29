import Foundation

enum DetailRoute: Hashable {
    case connect
    case session
    case summary
    case history
    case historyDetail(id: SessionSummary.ID)
    case settings
}
