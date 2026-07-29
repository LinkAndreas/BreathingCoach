import SwiftUI

/// Plots a completed session's EtCO₂ samples over time against the target band.
struct EtCO2SessionChartView: View {
    let summary: SessionSummary
    let units: DisplayUnit

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("EtCO₂ OVER SESSION")
                .font(.caption.weight(.semibold))
                .tracking(0.6)
                .foregroundStyle(Color.bcTextTertiary)

            Canvas { context, size in
                drawBand(context: context, size: size)
                drawLine(context: context, size: size)
                drawLabels(context: context, size: size)
            }
            .frame(height: 240)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.bcSecondaryBackground, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        .outline(cornerRadius: 12, lineWidth: 1, color: Color.bcBorder)
    }

    private func drawBand(context: GraphicsContext, size: CGSize) {
        let top = size.height - CGFloat(EtCO2Chart.normalized(summary.targetRange.upperBound)) * size.height
        let bottom = size.height - CGFloat(EtCO2Chart.normalized(summary.targetRange.lowerBound)) * size.height
        let rect = CGRect(x: 0, y: top, width: size.width, height: max(0, bottom - top))
        context.fill(Path(rect), with: .color(Color.bcPositive.opacity(0.12)))
    }

    private func drawLine(context: GraphicsContext, size: CGSize) {
        let points = summary.history
        guard points.count > 1 else { return }
        var path = Path()
        for (index, sample) in points.enumerated() {
            let x = size.width * CGFloat(index) / CGFloat(points.count - 1)
            let y = size.height - CGFloat(EtCO2Chart.normalized(sample.value)) * size.height
            if index == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        context.stroke(path, with: .color(Color.bcWaveformStroke), lineWidth: 2.2)
    }

    private func drawLabels(context: GraphicsContext, size: CGSize) {
        let maxY = size.height - CGFloat(EtCO2Chart.normalized(summary.targetRange.upperBound)) * size.height
        let minY = size.height - CGFloat(EtCO2Chart.normalized(summary.targetRange.lowerBound)) * size.height

        let maxLabel = Text("\(units.format(fromMmHg: summary.targetRange.upperBound)) \(units.label)")
            .font(.caption.monospaced())
            .foregroundStyle(Color.bcTextTertiary)
        let minLabel = Text("\(units.format(fromMmHg: summary.targetRange.lowerBound)) \(units.label)")
            .font(.caption.monospaced())
            .foregroundStyle(Color.bcTextTertiary)

        context.draw(maxLabel, at: CGPoint(x: 28, y: maxY + 10), anchor: .center)
        context.draw(minLabel, at: CGPoint(x: 28, y: minY - 10), anchor: .center)
    }
}

#Preview {
    EtCO2SessionChartView(
        summary: SessionSummary(
            date: Date(),
            duration: 180,
            avgEtco2: 38,
            peakEtco2: 44,
            avgRR: 12,
            pctInTarget: 62,
            startEtco2: 28,
            endEtco2: 40,
            history: (0..<120).map { EtCO2Sample(elapsed: Double($0), value: 28 + 12 * (Double($0) / 120)) },
            targetRange: 35...45,
            techniqueName: "CART"
        ),
        units: .mmHg
    )
    .frame(width: 700)
    .padding()
    .background(Color.bcBackground)
}
