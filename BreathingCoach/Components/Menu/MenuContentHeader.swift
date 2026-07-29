import SwiftUI

/// The large title, and optional explanatory subtitle, at the top of a detail screen.
struct MenuContentHeader: View {
    let title: LocalizedStringKey
    let subtitle: LocalizedStringKey?

    init(title: LocalizedStringKey, subtitle: LocalizedStringKey? = nil) {
        self.title = title
        self.subtitle = subtitle
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8.0) {
            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(Color.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
            if let subtitle {
                Text(subtitle)
                    .font(.body)
                    .foregroundStyle(Color.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

#Preview {
    MenuContentHeader(
        title: "Device Connection",
        subtitle: "Search for a nearby Capnostream monitor over serial / USB."
    )
}
