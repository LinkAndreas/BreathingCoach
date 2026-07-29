import SwiftUI

extension View {
    public func outline(cornerRadius: CGFloat = 0, lineWidth: CGFloat = 1, color: Color = .clear) -> some View {
        self.modifier(OutlineModifier(cornerRadius: cornerRadius, lineWidth: lineWidth, color: color))
    }
}

struct OutlineModifier: ViewModifier {
    let cornerRadius: CGFloat
    let lineWidth: CGFloat
    let color: Color

    func body(content: Content) -> some View {
        content
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .strokeBorder(style: StrokeStyle(lineWidth: lineWidth), antialiased: true)
                    .foregroundStyle(color)
            }
    }
}
