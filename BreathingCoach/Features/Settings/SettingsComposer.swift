import SwiftUI

/// The Settings screen, stacking each settings card in one column.
struct SettingsComposer: View {
    let viewModel: ConnectViewModel
    let showOnboarding: Action

    var body: some View {
        MenuContent(
            header: {
                MenuContentHeader(title: "Settings")
            },
            content: {
                VStack(alignment: .leading, spacing: 16) {
                    TargetRangeSettingsCard(viewModel: viewModel)
                    UnitsSettingsCard(viewModel: viewModel)
                    CustomPaceSettingsCard(viewModel: viewModel)
                    GuideSettingsCard(customPaceBreathsPerMinute: viewModel.customPaceBreathsPerMinute)
                    DemoModeSettingsCard(viewModel: viewModel)
                    AboutSettingsCard(showOnboarding: showOnboarding)
                }
                .frame(maxWidth: 560, alignment: .leading)
            }
        )
    }
}
