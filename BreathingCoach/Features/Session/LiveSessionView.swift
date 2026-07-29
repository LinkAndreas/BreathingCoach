import SwiftUI
import CapnostreamKit

struct LiveSessionView: View {
    let viewModel: ConnectViewModel
    let endSession: Action

    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 30.0)) { timeline in
            let elapsed = viewModel.sessionStartDate.map { timeline.date.timeIntervalSince($0) } ?? 0
            let technique = viewModel.selectedTechnique
            let segments = technique.segments(customBreathsPerMinute: viewModel.customPaceBreathsPerMinute)
            let pacerFrame = BreathingPacer.frame(elapsed: elapsed, segments: segments)
            let breathsPerMinute = technique.breathsPerMinute(customBreathsPerMinute: viewModel.customPaceBreathsPerMinute)

            let etco2 = viewModel.currentNummericsMessage?.etCO2.doubleValue
            let rr = viewModel.currentNummericsMessage?.respirationRate.doubleValue
            let spo2 = viewModel.currentNummericsMessage?.spO2.doubleValue
            let isInTarget = etco2.map { viewModel.targetRange.contains($0) } ?? false
            let pctInTarget = elapsed > 0 ? Int((viewModel.timeInTargetSeconds / elapsed * 100).rounded()) : 0
            let unitLabel = viewModel.units.label

            VStack(alignment: .leading, spacing: 18) {
                header(elapsed: elapsed, technique: technique)

                BreathingAssistantCardView(
                    phase: pacerFrame.phase,
                    scale: pacerFrame.scale,
                    caption: "\(String(localized: technique.name)) · \(formatted(breathsPerMinute)) breaths/min"
                )

                EtCO2CardView(
                    rawValue: etco2,
                    displayText: etco2.map { displayValue($0) } ?? "—",
                    unitLabel: unitLabel,
                    isInTarget: isInTarget,
                    targetRange: viewModel.targetRange,
                    targetCaption: "Target \(formatRange(viewModel.targetRange)) \(unitLabel)"
                )

                VStack(alignment: .leading, spacing: 14) {
                    CO2WaveformView(samples: viewModel.waveformSamples)
                        .frame(maxWidth: .infinity)

                    HStack(alignment: .top, spacing: 14) {
                        StatCardView(label: "RR", value: rr.map { String(format: "%.0f", $0) } ?? "—", unit: "bpm")
                            .frame(width: 96)

                        StatCardView(label: "SpO₂", value: spo2.map { String(format: "%.0f", $0) } ?? "—", unit: "%")
                            .frame(width: 96)

                        InTargetCardView(percent: pctInTarget)
                            .frame(minWidth: 140, maxWidth: .infinity, alignment: .leading)

                        TrendSparklineView(history: viewModel.etco2History, targetRange: viewModel.targetRange)
                            .frame(minWidth: 160, maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func header(elapsed: TimeInterval, technique: BreathingTechnique) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                Text(Self.formatElapsed(elapsed))
                    .font(.title3.monospaced().weight(.semibold))
                    .foregroundStyle(Color.bcTextPrimary)
                Spacer()
                Button("End Session", action: endSession)
                    .buttonStyle(.bcOutline(color: .bcNegative))
            }

            HStack(spacing: 10) {
                (Text("Target ") + Text("\(formatRange(viewModel.targetRange)) \(viewModel.units.label)"))
                    .font(.caption)
                    .foregroundStyle(Color.bcTextTertiary)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color.bcChipBackground, in: Capsule())

                Text(technique.name)
                    .font(.caption)
                    .foregroundStyle(Color.bcAccent)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color.bcAccent.opacity(0.12), in: Capsule())

                Button(action: { viewModel.changeTechnique() }) {
                    Text("Change").underline()
                }
                .buttonStyle(.plain)
                .font(.caption)
                .foregroundStyle(Color.bcTextTertiary)
            }
        }
    }

    private func displayValue(_ mmHg: Double) -> String {
        let converted = viewModel.units.convert(fromMmHg: mmHg)
        return viewModel.units == .mmHg ? String(format: "%.0f", converted) : String(format: "%.1f", converted)
    }

    private func formatted(_ breathsPerMinute: Double) -> String {
        String(format: "%.1f", breathsPerMinute)
    }

    private static func formatElapsed(_ seconds: TimeInterval) -> String {
        let total = max(0, Int(seconds))
        return String(format: "%d:%02d", total / 60, total % 60)
    }

    private func formatRange(_ range: ClosedRange<Double>) -> String {
        let lower = viewModel.units.convert(fromMmHg: range.lowerBound)
        let upper = viewModel.units.convert(fromMmHg: range.upperBound)
        return viewModel.units == .mmHg
            ? "\(Int(lower))–\(Int(upper))"
            : "\(String(format: "%.1f", lower))–\(String(format: "%.1f", upper))"
    }
}
