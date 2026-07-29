import Foundation

extension TimeInterval {
    /// The interval as a `m:ss` clock string, used for elapsed and total session times.
    /// Negative and non-finite intervals format as `0:00`.
    var clockString: String {
        guard isFinite else { return "0:00" }
        let total = max(0, Int(self))
        return String(format: "%d:%02d", total / 60, total % 60)
    }
}
