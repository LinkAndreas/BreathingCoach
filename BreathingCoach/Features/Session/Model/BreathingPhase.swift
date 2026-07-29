import Foundation

/// Which part of the breathing cycle the pacer is in. Both holds — after inhaling and after
/// exhaling — map to `hold`, since they are shown identically.
enum BreathingPhase: Equatable {
    case inhale
    case hold
    case exhale

    var label: LocalizedStringResource {
        switch self {
        case .inhale: "Breathe In"
        case .hold: "Hold"
        case .exhale: "Breathe Out"
        }
    }
}
