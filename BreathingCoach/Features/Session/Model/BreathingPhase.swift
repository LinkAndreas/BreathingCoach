import Foundation

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
