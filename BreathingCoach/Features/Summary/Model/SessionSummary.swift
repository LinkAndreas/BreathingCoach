import Foundation

/// Snapshot captured when a live session ends, used to populate the Summary and History screens.
struct SessionSummary: Identifiable {
    let id: UUID = UUID()
    let date: Date
    let duration: TimeInterval
    let avgEtco2: Double
    let peakEtco2: Double
    let avgRR: Double
    let pctInTarget: Int
    let startEtco2: Double
    let endEtco2: Double
    let history: [EtCO2Sample]
    let targetRange: ClosedRange<Double>
    let techniqueName: LocalizedStringResource

    var delta: Double { endEtco2 - startEtco2 }
}
