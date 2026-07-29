import Foundation

/// Constrains the value to `range`, used for keeping normalized chart positions inside 0...1.
extension Comparable {
    func clamped(to range: ClosedRange<Self>) -> Self {
        min(max(self, range.lowerBound), range.upperBound)
    }
}
