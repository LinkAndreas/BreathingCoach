import SwiftUI

/// A single row in the sidebar menu, styled for its selected state.
struct MenuItemView: View {
    let title: LocalizedStringKey
    let isSelected: Bool
    let onTap: () -> Void

    init(
        title: LocalizedStringKey,
        isSelected: Bool,
        onTap: @escaping () -> Void = {}
    ) {
        self.title = title
        self.isSelected = isSelected
        self.onTap = onTap
    }

    var body: some View {
        HStack(spacing: 8.0) {
            Image(systemName: "circle.fill")
                .font(.footnote)
                .foregroundStyle(isSelected ? Color.bcMenuItemSelectedForeground : Color.bcMenuItemForeground)
            Text(title)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 8.0)
        .padding(.vertical, 12.0)
        .background(isSelected ? Color.bcMenuItemSelectedBackground : Color.clear)
        .contentShape(Rectangle())
        .cornerRadius(8.0)
        .onTapGesture(perform: onTap)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    VStack(spacing: 8.0) {
        MenuItemView(title: "Connect", isSelected: true)
        MenuItemView(title: "Connect", isSelected: false)
    }
    .padding()
}
