import SwiftUI

struct TechniquePickerView: View {
    let viewModel: ConnectViewModel

    @State private var guideTechnique: BreathingTechnique?

    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            VStack(alignment: .leading, spacing: 12) {
                Text("BREATHING TECHNIQUE")
                    .font(.caption.weight(.semibold))
                    .tracking(0.8)
                    .foregroundStyle(Color.bcTextTertiary)

                VStack(spacing: 10) {
                    ForEach(BreathingTechnique.all) { technique in
                        TechniqueRow(
                            technique: technique,
                            isSelected: technique.id == viewModel.techniqueId,
                            breathsPerMinute: technique.breathsPerMinute(customBreathsPerMinute: viewModel.customPaceBreathsPerMinute),
                            action: { viewModel.selectTechnique(technique.id) },
                            showGuide: { guideTechnique = technique }
                        )
                    }
                }
            }

            Button("Start Breathing Session", action: { viewModel.startSession() })
                .buttonStyle(.bcFilled(color: .bcAccent))
        }
        .frame(maxWidth: 640, alignment: .leading)
        .sheet(item: $guideTechnique) { technique in
            BreathingTechniqueGuideView(
                technique: technique,
                customPaceBreathsPerMinute: viewModel.customPaceBreathsPerMinute,
                onClose: { guideTechnique = nil }
            )
            .frame(width: 640, height: 700)
        }
    }
}
