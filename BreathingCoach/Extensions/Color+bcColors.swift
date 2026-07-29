import SwiftUI

// MARK: - Capnostream Biofeedback palette
// Every token adapts to the current light/dark appearance via `Color(light:dark:)`.
// The dark values are sampled from the shipped dark UI; the light values mirror the
// same semantic roles, tuned for contrast on light surfaces.

public extension Color {

    // MARK: Plain backgrounds (full-bleed content)

    /// Main content background.
    static let bcBackground = Color(light: Color(hex: 0xF5F7FA), dark: Color(hex: 0x0E121B))

    /// First elevated layer (section containers, panels).
    static let bcSecondaryBackground = Color(light: Color(hex: 0xFFFFFF), dark: Color(hex: 0x141A2A))

    /// Second elevated layer (selection, hover, nested surfaces).
    static let bcTertiaryBackground = Color(light: Color(hex: 0xEDEFF3), dark: Color(hex: 0x182231))

    // MARK: Grouped backgrounds (list-style screens)

    /// Behind a grouped list / section card.
    static let bcGroupedBackground = Color(light: Color(hex: 0xF0F2F5), dark: Color(hex: 0x141A2A))

    /// The cells themselves.
    static let bcSecondaryGroupedBackground = Color(light: Color(hex: 0xFFFFFF), dark: Color(hex: 0x0F141F))

    /// Content nested inside cells, selected rows.
    static let bcTertiaryGroupedBackground = Color(light: Color(hex: 0xE4E7EC), dark: Color(hex: 0x182231))

    // MARK: Chrome

    /// Sidebar background.
    static let bcSidebarBackground = Color(light: Color(hex: 0xEEF0F4), dark: Color(hex: 0x0B0E16))

    /// Title bar / toolbar background.
    static let bcBarBackground = Color(light: Color(hex: 0xF7F8FA), dark: Color(hex: 0x11141E))

    // MARK: Text

    /// Primary text.
    static let bcTextPrimary = Color(light: Color(hex: 0x101418), dark: Color(hex: 0xE9EDF5))

    /// Secondary text (subtitles, metadata).
    static let bcTextSecondary = Color(light: Color(hex: 0x5B6472), dark: Color(hex: 0x8892AB))

    /// Tertiary text (section labels, captions).
    static let bcTextTertiary = Color(light: Color(hex: 0x828B99), dark: Color(hex: 0x5A647D))

    /// Disabled / unavailable text.
    static let bcTextDisabled = Color(light: Color(hex: 0xB8BEC7), dark: Color(hex: 0x414A61))

    // MARK: Menu items (sidebar navigation)

    /// Selected menu item background.
    static let bcMenuItemSelectedBackground = Color(light: Color(hex: 0xDCE6F5), dark: Color(hex: 0x182231))

    /// Selected menu item label and indicator dot.
    static let bcMenuItemSelectedForeground = Color(light: Color(hex: 0x2F6FBF), dark: Color(hex: 0x6A9AD4))

    /// Unselected menu item label.
    static let bcMenuItemForeground = Color(light: Color(hex: 0x5B6472), dark: Color(hex: 0x8892AB))

    /// Unselected menu item indicator dot.
    static let bcMenuItemIndicator = Color(light: Color(hex: 0xB8BEC7), dark: Color(hex: 0x414A61))

    /// Sidebar section header (e.g. "EtCO₂ trainer").
    static let bcMenuSectionHeader = Color(light: Color(hex: 0x828B99), dark: Color(hex: 0x414A61))

    // MARK: Accents

    /// Interactive blue (links, active nav).
    static let bcAccent = Color(light: Color(hex: 0x2F6FBF), dark: Color(hex: 0x6A9AD4))

    /// Positive / connect mint.
    static let bcPositive = Color(light: Color(hex: 0x1E9E74), dark: Color(hex: 0x77D6B3))

    /// Negative / error coral (icons, headlines).
    static let bcNegative = Color(light: Color(hex: 0xC94436), dark: Color(hex: 0xDF7368))

    /// Negative border on error containers.
    static let bcNegativeBorder = Color(light: Color(hex: 0xE8B4AC), dark: Color(hex: 0x5B393F))

    /// Warning / out-of-target amber.
    static let bcWarning = Color(light: Color(hex: 0xB8790A), dark: Color(hex: 0xE8B34D))

    // MARK: Filled buttons

    /// Text on filled buttons (accent/positive backgrounds).
    static let bcFilledButtonText = Color(light: Color(hex: 0xFFFFFF), dark: Color(hex: 0x0E121B))

    /// Default border / separator color.
    static let bcBorder = Color(light: Color(hex: 0xD8DCE3), dark: Color(hex: 0x2A3140))

    // MARK: Overlays

    /// Recessed track behind sliders / progress bars.
    static let bcTrackBackground = Color(light: Color.black.opacity(0.08), dark: Color.black.opacity(0.35))

    /// Subtle chip/pill background over a card surface.
    static let bcChipBackground = Color(light: Color.black.opacity(0.05), dark: Color.white.opacity(0.05))

    /// Faint grid lines on charts/waveforms.
    static let bcGridLine = Color(light: Color.black.opacity(0.08), dark: Color.white.opacity(0.06))

    /// Waveform / trend line stroke color.
    static let bcWaveformStroke = Color(light: Color(hex: 0x0E8272), dark: Color(hex: 0x5FD4C4))
}
