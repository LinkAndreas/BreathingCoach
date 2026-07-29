import Foundation

/// The pressure unit EtCO₂ values are displayed in.
///
/// The monitor always reports EtCO₂ in mmHg, so every value in the app is stored in mmHg and
/// converted only at the point of display. This type owns both the conversion and the formatting
/// so the Session, Summary, History and Settings screens render identical values.
enum DisplayUnit: String, CaseIterable {
    case mmHg
    case kPa

    /// Conversion factor from millimetres of mercury to kilopascals.
    private static let kPaPerMmHg = 0.13332

    /// The unit's user-facing suffix, e.g. `"mmHg"`.
    var label: String { rawValue }

    /// Number of fraction digits used when displaying a value in this unit.
    ///
    /// kPa values are roughly an eighth of the equivalent mmHg value, so they need a decimal
    /// place to stay meaningful.
    private var fractionDigits: Int {
        switch self {
        case .mmHg: 0
        case .kPa: 1
        }
    }

    /// Converts a value stored in mmHg into this unit.
    func convert(fromMmHg value: Double) -> Double {
        self == .mmHg ? value : value * Self.kPaPerMmHg
    }

    /// Converts and formats a single mmHg value for display, without the unit label.
    func format(fromMmHg value: Double) -> String {
        String(format: "%.\(fractionDigits)f", convert(fromMmHg: value))
    }

    /// Converts and formats a value with an explicit sign, used for session deltas.
    func formatSigned(fromMmHg value: Double) -> String {
        (value >= 0 ? "+" : "") + String(format: "%.1f", convert(fromMmHg: value))
    }

    /// Converts and formats a target range as `"35–45"`, without the unit label.
    func formatRange(fromMmHg range: ClosedRange<Double>) -> String {
        "\(format(fromMmHg: range.lowerBound))–\(format(fromMmHg: range.upperBound))"
    }
}
