import Foundation

/// A single EtCO₂ reading captured during a live session, timestamped relative to session start.
struct EtCO2Sample: Equatable {
    let elapsed: TimeInterval
    let value: Double
}
