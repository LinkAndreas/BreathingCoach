import SwiftUI

/// The live EtCO₂ readout — second most prominent widget, directly under the
/// Breathing Assistant. Owns all EtCO₂-target color feedback (value color, band, marker).
struct EtCO2CardView: View {
    /// Raw mmHg reading, used to position the target-band marker. The display text is
    /// formatted separately so it can reflect the user's chosen display unit.
    let rawValue: Double?
    let displayText: String
    let unitLabel: String
    let isInTarget: Bool
    let targetRange: ClosedRange<Double>
    let targetCaption: String

    private var valueColor: Color { isInTarget ? .bcPositive : .bcWarning }

    var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 4) {
                Text("EtCO₂")
                    .font(.caption.weight(.semibold))
                    .tracking(0.6)
                    .foregroundStyle(Color.bcTextTertiary)

                HStack(alignment: .lastTextBaseline, spacing: 6) {
                    Text(displayText)
                        .font(.system(size: 52, weight: .bold, design: .monospaced))
                        .foregroundStyle(valueColor)
                    Text(unitLabel)
                        .font(.callout)
                        .foregroundStyle(Color.bcTextSecondary)
                }
            }

            TargetBandView(targetRange: targetRange, currentValue: rawValue, caption: targetCaption)
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(Color.bcSecondaryBackground, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .outline(cornerRadius: 16, lineWidth: 1, color: valueColor.opacity(0.3))
    }
}

#Preview {
    EtCO2CardView(
        rawValue: 41,
        displayText: "41",
        unitLabel: "mmHg",
        isInTarget: true,
        targetRange: 35...45,
        targetCaption: "Target 35–45 mmHg"
    )
    .padding()
    .background(Color.bcBackground)
}
