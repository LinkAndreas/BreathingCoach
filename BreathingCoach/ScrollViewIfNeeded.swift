import SwiftUI

/// Wraps content in a `ScrollView` only when it does not fit vertically, so short content stays
/// put instead of becoming needlessly scrollable.
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
