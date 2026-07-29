import SwiftUI

struct OnboardingPageIndicator: View {
    let pageCount: Int
    let currentPage: Int

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<pageCount, id: \.self) { index in
                Capsule()
                    .fill(index == currentPage ? Color.bcAccent : Color.bcTextDisabled)
                    .frame(width: index == currentPage ? 18 : 6, height: 6)
                    .animation(.easeInOut(duration: 0.2), value: currentPage)
            }
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    OnboardingPageIndicator(pageCount: 4, currentPage: 1)
        .padding()
        .background(Color.bcBackground)
}
