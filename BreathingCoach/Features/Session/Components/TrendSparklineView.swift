import SwiftUI

struct TrendSparklineView: View {
    let history: [EtCO2Sample]
    let targetRange: ClosedRange<Double>

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("TREND (2 MIN)")
                .font(.caption.weight(.semibold))
                .tracking(0.6)
                .foregroundStyle(Color.bcTextTertiary)

            Canvas { context, size in
                drawBand(context: context, size: size)
                drawLine(context: context, size: size)
            }
            .frame(height: 40)
        }
        .padding(14)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background(Color.bcSecondaryBackground, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        .outline(cornerRadius: 12, lineWidth: 1, color: Color.bcBorder)
    }

    private var recent: [EtCO2Sample] {
        guard let latest = history.last?.elapsed else { return [] }
        return history.filter { latest - $0.elapsed <= 120 }
    }

    private func drawBand(context: GraphicsContext, size: CGSize) {
        let bandTop = size.height - CGFloat(EtCO2Chart.normalized(targetRange.upperBound)) * size.height
        let bandHeight = CGFloat(EtCO2Chart.normalized(targetRange.upperBound) - EtCO2Chart.normalized(targetRange.lowerBound)) * size.height
        let rect = CGRect(x: 0, y: bandTop, width: size.width, height: max(0, bandHeight))
        context.fill(Path(rect), with: .color(Color.bcPositive.opacity(0.14)))
    }

    private func drawLine(context: GraphicsContext, size: CGSize) {
        let points = recent
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
        context.stroke(path, with: .color(Color.bcWaveformStroke), lineWidth: 1.6)
    }
}

#Preview {
    TrendSparklineView(
        history: (0..<120).map { EtCO2Sample(elapsed: Double($0), value: 30 + 10 * sin(Double($0) / 15)) },
        targetRange: 35...45
    )
    .frame(width: 280)
    .padding()
    .background(Color.bcBackground)
}
