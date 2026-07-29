import SwiftUI

struct MenuContent<Header: View, Content: View>: View {
    let header: () -> Header
    let content: () -> Content
    
    init(
        @ViewBuilder header: @escaping () -> Header,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.header = header
        self.content = content
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16.0) {
                header()
                content()
            }
        }
        .contentMargins(16.0)
        .background(Color.bcBackground)
    }
}

#Preview(traits: .fixedLayout(width: 500, height: 250)) {
    MenuContent(
        header: {
            Color.blue
        },
        content: {
            Color.red
        }
    )
}
