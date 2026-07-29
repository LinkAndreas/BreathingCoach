import SwiftUI

/// A standard top-right circular dismiss control for custom modal sheets, so the
/// whole sheet shares one continuous background instead of separate title-bar chrome.
struct ModalCloseButton: View {
    let action: Action

    var body: some View {
        Button(action: action) {
            Image(systemName: "xmark")
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(Color.bcTextSecondary)
                .frame(width: 28, height: 28)
                .background(Color.bcChipBackground, in: Circle())
        }
        .buttonStyle(.plain)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    ModalCloseButton(action: {})
        .padding()
        .background(Color.bcBackground)
}
