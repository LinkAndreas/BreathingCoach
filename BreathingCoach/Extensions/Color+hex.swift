import SwiftUI

public extension Color {
    /// Creates an sRGB color from a 24-bit RGB hex value, e.g. `Color(hex: 0x0E121B)`.
    init(hex: UInt32, opacity: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: opacity
        )
    }
}
