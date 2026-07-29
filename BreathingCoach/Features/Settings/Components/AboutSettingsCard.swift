import SwiftUI

struct AboutSettingsCard: View {
    let showOnboarding: Action

    var body: some View {
        SettingsCard(title: "About") {
            Button("Replay Onboarding", action: showOnboarding)
                .buttonStyle(.bcOutline(color: .bcAccent))
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    AboutSettingsCard(showOnboarding: {})
        .frame(width: 480)
        .padding()
        .background(Color.bcBackground)
}
