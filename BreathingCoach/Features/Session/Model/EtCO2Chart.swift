import Foundation

/// Shared display scale used by the target band and trend sparkline so a given
/// EtCO₂ reading always maps to the same vertical position across the session UI.
enum EtCO2Chart {
    static let scaleRange: ClosedRange<Double> = 15...55

    static func normalized(_ value: Double) -> Double {
        ((value - scaleRange.lowerBound) / (scaleRange.upperBound - scaleRange.lowerBound))
            .clamped(to: 0...1)
    }
}
