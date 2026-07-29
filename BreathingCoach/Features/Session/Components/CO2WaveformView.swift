import SwiftUI

/// The scrolling capnogram: the raw ~20 Hz CO₂ waveform straight from the monitor.
struct CO2WaveformView: View {
    let samples: [Double]
    var unitLabel: String = "mmHg"

    private let scaleRange: ClosedRange<Double> = 0...50

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("CO₂ WAVEFORM")
                    .font(.caption.weight(.semibold))
                    .tracking(0.6)
                    .foregroundStyle(Color.bcTextTertiary)
                Spacer()
                Text(unitLabel)
                    .font(.caption)
                    .foregroundStyle(Color.bcTextTertiary)
            }

            Canvas { context, size in
                drawGrid(context: context, size: size)
                drawWave(context: context, size: size)
            }
            .frame(height: 100)
            .background(Color.bcSecondaryGroupedBackground, in: RoundedRectangle(cornerRadius: 6, style: .continuous))
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.bcSecondaryBackground, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        .outline(cornerRadius: 12, lineWidth: 1, color: Color.bcBorder)
    }

    private func drawGrid(context: GraphicsContext, size: CGSize) {
        var path = Path()
        var x: CGFloat = 0
        while x < size.width {
            path.move(to: CGPoint(x: x, y: 0))
            path.addLine(to: CGPoint(x: x, y: size.height))
            x += 40
        }
        var y: CGFloat = 0
        while y < size.height {
            path.move(to: CGPoint(x: 0, y: y))
            path.addLine(to: CGPoint(x: size.width, y: y))
            y += 30
        }
        context.stroke(path, with: .color(Color.bcGridLine), lineWidth: 1)
    }

    private func drawWave(context: GraphicsContext, size: CGSize) {
        guard samples.count > 1 else { return }
        let n = samples.count
        var path = Path()
        for (index, sample) in samples.enumerated() {
            let x = size.width * CGFloat(index) / CGFloat(n - 1)
            let normalized = ((sample - scaleRange.lowerBound) / (scaleRange.upperBound - scaleRange.lowerBound))
                .clamped(to: 0...1)
            let y = size.height - 6 - CGFloat(normalized) * (size.height - 12)
            if index == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        context.stroke(path, with: .color(Color.bcWaveformStroke), lineWidth: 2)
    }
}

#Preview {
    CO2WaveformView(samples: (0..<180).map { 0.03 + 0.4 * abs(sin(Double($0) / 12)) })
        .frame(width: 400)
        .padding()
        .background(Color.bcBackground)
}
