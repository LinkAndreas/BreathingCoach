import SwiftUI

struct ScrollViewIfNeeded<Content: View>: View {
    let content: () -> Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    var body: some View {
        ViewThatFits(in: .vertical) {
            content()
            ScrollView(.vertical) {
                content()
            }
        }
    }
}
