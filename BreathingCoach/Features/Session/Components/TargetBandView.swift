import SwiftUI

/// A horizontal scale with the target range highlighted and a marker at the current reading.
/// Positions come from `EtCO2Chart` so this and the sparkline share one scale.
struct TargetBandView: View {
    let targetRange: ClosedRange<Double>
    let currentValue: Double?
    let caption: String

    var body: some View {
        VStack(spacing: 8) {
            GeometryReader { proxy in
                let width = proxy.size.width
                let bandStart = EtCO2Chart.normalized(targetRange.lowerBound) * width
                let bandEnd = EtCO2Chart.normalized(targetRange.upperBound) * width

                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.bcTrackBackground)

                    Capsule()
                        .fill(Color.bcPositive.opacity(0.28))
                        .frame(width: max(0, bandEnd - bandStart))
                        .offset(x: bandStart)

                    if let currentValue {
                        Capsule()
                            .fill(Color.bcTextPrimary)
                            .frame(width: 3, height: 16)
                            .offset(x: (EtCO2Chart.normalized(currentValue) * width - 1.5).clamped(to: 0...(width - 3)), y: -3)
                    }
                }
            }
            .frame(height: 10)

            Text(caption)
                .font(.caption)
                .foregroundStyle(Color.bcTextTertiary)
        }
        .frame(maxWidth: 300)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    TargetBandView(targetRange: 35...45, currentValue: 41, caption: "Target 35–45 mmHg · CART · 6.0 breaths/min")
        .padding()
        .background(Color.bcBackground)
}
