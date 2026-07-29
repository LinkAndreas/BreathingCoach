import Foundation

extension Date {
    /// The date rendered the way completed sessions are labelled throughout the app,
    /// e.g. `"23 Jul 2026 at 09:41"`, localized to the user's locale.
    var sessionTimestamp: String {
        formatted(date: .abbreviated, time: .shortened)
    }
}
