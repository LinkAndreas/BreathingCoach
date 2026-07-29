import NavigationKit
import SwiftUI

struct SessionComposer: View {
    let viewModel: ConnectViewModel
    let navigator: StackNavigator
    let goToConnect: () -> Void
    let goToSummary: () -> Void

    var body: some View {
        MenuContent(
            header: {
                MenuContentHeader(
                    title: "Live Session",
                    subtitle: viewModel.isLiveSessionActive ? nil : subtitle
                )
            },
            content: {
                if viewModel.isConnected {
                    if viewModel.isLiveSessionActive {
                        LiveSessionView(
                            viewModel: viewModel,
                            endSession: {
                                viewModel.endSession()
                                goToSummary()
                            }
                        )
                    } else {
                        TechniquePickerView(viewModel: viewModel)
                    }
                } else {
                    Button("Go to Connect", action: goToConnect)
                        .buttonStyle(.bcFilled(color: Color.bcAccent))
                }
            }
        )
    }

    private var subtitle: LocalizedStringKey {
        viewModel.isConnected
            ? "No active session. Start a breathing session to see live biofeedback."
            : "Connect a device before starting a session."
    }
}
