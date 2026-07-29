import CapnostreamKit

extension NumericsMessage {
    /// The subset of this snapshot the session UI displays.
    var liveReadings: LiveReadings {
        LiveReadings(
            etco2: etCO2.doubleValue,
            respirationRate: respirationRate.doubleValue,
            spo2: spO2.doubleValue
        )
    }
}
