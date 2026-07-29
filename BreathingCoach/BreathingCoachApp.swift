import SwiftUI

@main struct BreathingCoachApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .toolbarBackground(Color.bcBarBackground, for: .windowToolbar)
                .toolbarBackgroundVisibility(.visible, for: .windowToolbar)
        }
    }
}
