import SwiftUI

/// Browsable guide to all breathing techniques, presented as its own self-contained
/// navigation stack inside a sheet.
struct BreathingGuideListView: View {
    var customPaceBreathsPerMinute: Double = 6
    let onDismiss: Action

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(BreathingTechnique.all) { technique in
                        NavigationLink {
                            BreathingTechniqueGuideView(
                                technique: technique,
                                customPaceBreathsPerMinute: customPaceBreathsPerMinute
                            )
                            .navigationTitle(technique.name)
                        } label: {
                            GuideTechniqueRow(technique: technique)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(20)
                .frame(maxWidth: 560)
            }
            .background(Color.bcBackground)
            .navigationTitle("Breathing Technique Guide")
            .toolbarBackground(Color.bcBackground, for: .windowToolbar)
            .toolbarBackgroundVisibility(.visible, for: .windowToolbar)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    ModalCloseButton(action: onDismiss)
                }
            }
        }
        .frame(width: 640, height: 720)
    }
}

#Preview {
    BreathingGuideListView(onDismiss: {})
}
