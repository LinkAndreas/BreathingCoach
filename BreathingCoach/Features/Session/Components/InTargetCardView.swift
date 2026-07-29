import SwiftUI

/// Shows what share of the session has been spent inside the EtCO₂ target range.
struct InTargetCardView: View {
    let percent: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("IN TARGET")
                    .font(.caption.weight(.semibold))
                    .tracking(0.6)
                    .foregroundStyle(Color.bcTextTertiary)
                Spacer()
                Text("\(percent)%")
                    .font(.caption.monospaced())
                    .foregroundStyle(Color.bcPositive)
            }
            GeometryReader { proxy in
                ZStack(alignment: .leading) {
                    Capsule().fill(Color.bcTrackBackground)
                    Capsule()
                        .fill(Color.bcPositive)
                        .frame(width: proxy.size.width * CGFloat(percent) / 100)
                }
            }
            .frame(height: 5)
        }
        .padding(14)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background(Color.bcSecondaryBackground, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        .outline(cornerRadius: 12, lineWidth: 1, color: Color.bcBorder)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    InTargetCardView(percent: 62)
        .frame(width: 150)
        .padding()
        .background(Color.bcBackground)
}
