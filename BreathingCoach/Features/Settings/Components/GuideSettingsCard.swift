import SwiftUI

/// Opens the breathing technique guide from Settings.
struct GuideSettingsCard: View {
    let customPaceBreathsPerMinute: Double

    @State private var isGuidePresented = false

    var body: some View {
        SettingsCard(
            title: "Breathing Technique Guide",
            subtitle: "Learn how each technique works, its benefits, and how to practice it."
        ) {
            Button("Open Guide", action: { isGuidePresented = true })
                .buttonStyle(.bcOutline(color: .bcAccent))
        }
        .sheet(isPresented: $isGuidePresented) {
            BreathingGuideListView(
                customPaceBreathsPerMinute: customPaceBreathsPerMinute,
                onDismiss: { isGuidePresented = false }
            )
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    GuideSettingsCard(customPaceBreathsPerMinute: 6)
        .frame(width: 480)
        .padding()
        .background(Color.bcBackground)
}
