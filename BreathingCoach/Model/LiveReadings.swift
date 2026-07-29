import Foundation

/// The numeric readings the UI displays, taken from the monitor's once-per-second snapshot.
///
/// The views deliberately depend on this rather than on `NumericsMessage`, so the session UI has no
/// knowledge of the transport — which is also what lets demo mode drive the same screens without a
/// device attached.
///
/// Each value is `nil` when the monitor reports it as invalid or the parameter is not fitted.
struct LiveReadings: Equatable {
    /// End-tidal CO₂, in mmHg.
    let etco2: Double?
    /// Respiration rate, in breaths per minute.
    let respirationRate: Double?
    /// Blood-oxygen saturation, as a percentage.
    let spo2: Double?
}
