import SwiftUI

/// The app's button styles: filled for primary actions, outline for secondary ones, plain for
/// inline text actions. Each takes the accent color to use so callers stay declarative.
extension ButtonStyle where Self == BCFilledButtonStyle {
    static func bcFilled(color: Color) -> BCFilledButtonStyle { BCFilledButtonStyle(color: color) }
}

extension ButtonStyle where Self == BCOutlineButtonStyle {
    static func bcOutline(color: Color) -> BCOutlineButtonStyle { BCOutlineButtonStyle(color: color) }
}

extension ButtonStyle where Self == BCPlainButtonStyle {
    static func bcPlain(color: Color) -> BCPlainButtonStyle { BCPlainButtonStyle(color: color) }
}

struct BCFilledButtonStyle: ButtonStyle {
    let color: Color
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .fontWeight(.bold)
            .padding(10)
            .foregroundStyle(Color.bcFilledButtonText)
            .background(color)
            .cornerRadius(8)
            .opacity(isEnabled ? (configuration.isPressed ? 0.7 : 1.0) : 0.4)
            .contentShape(Rectangle())
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

struct BCOutlineButtonStyle: ButtonStyle {
    let color: Color
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(10)
            .foregroundStyle(Color.bcTextPrimary)
            .outline(cornerRadius: 8.0, lineWidth: 1.0, color: color)
            .cornerRadius(8)
            .opacity(isEnabled ? (configuration.isPressed ? 0.6 : 1.0) : 0.4)
            .contentShape(Rectangle())
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

struct BCPlainButtonStyle: ButtonStyle {
    let color: Color
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(10)
            .foregroundStyle(color)
            .opacity(isEnabled ? (configuration.isPressed ? 0.5 : 1.0) : 0.4)
            .contentShape(Rectangle())
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

#Preview {
    VStack(alignment: .leading, spacing: 8.0) {
        Button("Start Session", action: {})
            .buttonStyle(.bcFilled(color: .bcPositive))
        Button("Connect", action: {})
            .buttonStyle(.bcOutline(color: .bcPositive))
        Button("Disconnect", action: {})
            .buttonStyle(.bcPlain(color: .bcTextSecondary))
        Button("Disabled", action: {})
            .buttonStyle(.bcFilled(color: .bcPositive))
            .disabled(true)
    }
    .padding()
}
