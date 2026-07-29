import CapnostreamKit

extension MonitorValue {
    /// The numeric reading, or `nil` when the monitor reports the value as invalid/not supported.
    var doubleValue: Double? {
        switch self {
        case let .value(v): Double(v)
        case .invalid, .notSupported: nil
        }
    }
}
