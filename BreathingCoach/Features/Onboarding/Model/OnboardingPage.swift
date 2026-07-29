import Foundation

struct OnboardingPage: Identifiable {
    let id: Int
    let systemImage: String
    let title: LocalizedStringResource
    let message: LocalizedStringResource
}

extension OnboardingPage {
    static let all: [OnboardingPage] = [
        OnboardingPage(
            id: 0,
            systemImage: "lungs.fill",
            title: "Welcome to EtCO₂ Trainer",
            message: "Train your breathing with real-time capnography biofeedback from your Capnostream monitor."
        ),
        OnboardingPage(
            id: 1,
            systemImage: "cable.connector",
            title: "Connect Your Monitor",
            message: "Plug in a Capnostream monitor over serial or USB, then scan and connect from the Connect tab."
        ),
        OnboardingPage(
            id: 2,
            systemImage: "waveform.path.ecg.rectangle",
            title: "Breathe With Live Feedback",
            message: "Pick a breathing technique and follow the pacer while your EtCO₂, respiration rate, and SpO₂ stream live."
        ),
        OnboardingPage(
            id: 3,
            systemImage: "chart.xyaxis.line",
            title: "Track Your Progress",
            message: "Review each session's summary, browse your history, and tune your target range in Settings."
        ),
    ]
}
