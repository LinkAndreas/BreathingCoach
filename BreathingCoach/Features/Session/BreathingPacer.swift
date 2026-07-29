import Foundation

/// Computes the current breathing phase and pacer-circle scale for a point in time,
/// given the active technique's segment timings. Pure/stateless so it can be driven
/// directly from a `TimelineView`.
enum BreathingPacer {
    struct Frame: Equatable {
        let phase: BreathingPhase
        /// Pacer circle scale, animates between 0.62 (fully exhaled) and 1.0 (fully inhaled).
        let scale: Double
    }

    private static let minScale = 0.62
    private static let maxScale = 1.0

    static func frame(elapsed: TimeInterval, segments: BreathingTechnique.Segments) -> Frame {
        let cycle = segments.cycleDuration
        guard cycle > 0, elapsed.isFinite else {
            return Frame(phase: .inhale, scale: minScale)
        }

        let t = elapsed.truncatingRemainder(dividingBy: cycle)
        let ease: (Double) -> Double = { 0.5 - 0.5 * cos(.pi * $0) }
        let inhaleEnd = segments.inhale
        let holdInEnd = inhaleEnd + segments.holdIn
        let exhaleEnd = holdInEnd + segments.exhale

        if t < inhaleEnd {
            let fraction = segments.inhale > 0 ? t / segments.inhale : 1
            let scale = minScale + ease(fraction) * (maxScale - minScale)
            return Frame(phase: .inhale, scale: scale)
        } else if t < holdInEnd {
            return Frame(phase: .hold, scale: maxScale)
        } else if t < exhaleEnd {
            let fraction = segments.exhale > 0 ? (t - holdInEnd) / segments.exhale : 1
            let scale = maxScale - ease(fraction) * (maxScale - minScale)
            return Frame(phase: .exhale, scale: scale)
        } else {
            return Frame(phase: .hold, scale: minScale)
        }
    }
}
