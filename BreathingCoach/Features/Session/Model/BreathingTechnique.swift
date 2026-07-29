import Foundation

struct BreathingTechnique: Identifiable, Equatable {
    struct Segments: Equatable {
        let inhale: TimeInterval
        let holdIn: TimeInterval
        let exhale: TimeInterval
        let holdOut: TimeInterval

        var cycleDuration: TimeInterval { inhale + holdIn + exhale + holdOut }
    }

    let id: String
    let name: LocalizedStringResource
    let subtitle: LocalizedStringResource
    let description: LocalizedStringResource
    /// Longer-form rationale shown in the technique guide, beyond the one-line `description`.
    let benefits: LocalizedStringResource
    /// Ordered how-to-practice steps shown in the technique guide.
    let steps: [LocalizedStringResource]
    /// `nil` for the custom-pace technique, whose segments are derived from the user's pace setting.
    let segments: Segments?

    func segments(customBreathsPerMinute: Double) -> Segments {
        guard let segments else {
            let cycle = 60 / max(customBreathsPerMinute, 0.1)
            return Segments(inhale: cycle * 0.4, holdIn: 0, exhale: cycle * 0.6, holdOut: 0)
        }
        return segments
    }

    func breathsPerMinute(customBreathsPerMinute: Double) -> Double {
        60 / segments(customBreathsPerMinute: customBreathsPerMinute).cycleDuration
    }
}

extension BreathingTechnique {
    static let all: [BreathingTechnique] = [
        BreathingTechnique(
            id: "cart",
            name: "CART",
            subtitle: "Capnometry-Assisted Respiratory Training",
            description: "Slow diaphragmatic breathing at a fixed pace, clinically used to correct hyperventilation and raise EtCO₂.",
            benefits: "Clinically shown to reduce hyperventilation symptoms such as dizziness, chest tightness, and anxiety by gradually raising EtCO₂ toward a normal range.",
            steps: [
                "Sit upright and relax your shoulders.",
                "Inhale gently through your nose for 4 seconds, expanding your belly rather than your chest.",
                "Exhale slowly through your nose or pursed lips for 6 seconds.",
                "Repeat at a steady, comfortable pace, following the on-screen pacer.",
            ],
            segments: Segments(inhale: 4, holdIn: 0, exhale: 6, holdOut: 0)
        ),
        BreathingTechnique(
            id: "coherent",
            name: "Coherent Breathing",
            subtitle: "Resonance-frequency breathing",
            description: "Equal inhale/exhale near 6 breaths/min — maximizes heart-rate variability and steadies respiration.",
            benefits: "Breathing at resonance frequency (around 6 breaths/min) maximizes heart-rate variability, activating the parasympathetic nervous system and promoting calm.",
            steps: [
                "Sit or lie down comfortably.",
                "Inhale through your nose for 5 seconds.",
                "Exhale through your nose for 5 seconds — no pause at the top or bottom.",
                "Keep the rhythm smooth and continuous for several minutes.",
            ],
            segments: Segments(inhale: 5, holdIn: 0, exhale: 5, holdOut: 0)
        ),
        BreathingTechnique(
            id: "buteyko",
            name: "Buteyko Reduced Breathing",
            subtitle: "Control-pause method",
            description: "Gentle, reduced-volume nasal breathing with a brief pause after exhale to build CO₂ tolerance.",
            benefits: "Builds tolerance to CO₂ and reduces chronic over-breathing, which can ease asthma-like symptoms and nasal congestion over time.",
            steps: [
                "Breathe only through your nose throughout the exercise.",
                "Take a smaller, gentler breath in than feels natural for 2 seconds.",
                "Exhale gently for 3 seconds.",
                "Pause briefly for 4 seconds before the next breath, staying relaxed.",
            ],
            segments: Segments(inhale: 2, holdIn: 0, exhale: 3, holdOut: 4)
        ),
        BreathingTechnique(
            id: "pursed",
            name: "Pursed-Lip Breathing",
            subtitle: "2:1 ratio",
            description: "Inhale through the nose, exhale twice as long through pursed lips to slow RR and prevent air trapping.",
            benefits: "Slows respiration rate and keeps airways open longer during exhalation, reducing air trapping — commonly used in COPD pulmonary rehabilitation.",
            steps: [
                "Inhale quietly through your nose for about 3 seconds.",
                "Purse your lips as if about to whistle.",
                "Exhale slowly and gently through pursed lips for about twice as long, 6 seconds.",
                "Keep your shoulders relaxed throughout.",
            ],
            segments: Segments(inhale: 3, holdIn: 0, exhale: 6, holdOut: 0)
        ),
        BreathingTechnique(
            id: "478",
            name: "4-7-8 Breathing",
            subtitle: "Weil method",
            description: "Inhale 4s, hold 7s, exhale 8s — a breath-hold-heavy pattern that raises EtCO₂ quickly.",
            benefits: "The extended breath hold and long exhale quickly raise EtCO₂ and are widely used to ease acute anxiety and support falling asleep.",
            steps: [
                "Exhale completely through your mouth.",
                "Inhale quietly through your nose for 4 seconds.",
                "Hold your breath for 7 seconds.",
                "Exhale completely through your mouth for 8 seconds, making a whoosh sound.",
            ],
            segments: Segments(inhale: 4, holdIn: 7, exhale: 8, holdOut: 0)
        ),
        BreathingTechnique(
            id: "custom",
            name: "Custom Pace",
            subtitle: "From Settings",
            description: "Your own pace set in Settings, 40% inhale / 60% exhale ratio.",
            benefits: "Lets you fine-tune inhale/exhale timing to match a technique your clinician recommended, or to gradually adjust your pace over time.",
            steps: [
                "Open Settings and set your desired breathing rate.",
                "Return to Live Session and select Custom Pace.",
                "Follow the pacer — inhale takes 40% of each cycle, exhale the remaining 60%.",
            ],
            segments: nil
        ),
    ]

    static let `default` = all[0]

    static func find(id: String) -> BreathingTechnique {
        all.first(where: { $0.id == id }) ?? .default
    }
}
