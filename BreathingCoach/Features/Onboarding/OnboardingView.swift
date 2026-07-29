import SwiftUI

/// The first-run introduction, presented as a sheet and replayable from Settings.
struct OnboardingView: View {
    let onFinish: Action

    @State private var currentPage = 0

    private let pages = OnboardingPage.all

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                if currentPage < pages.count - 1 {
                    Button("Skip", action: onFinish)
                        .buttonStyle(.bcPlain(color: .bcTextSecondary))
                }
            }
            .padding([.top, .trailing], 12)
            .frame(height: 40)

            OnboardingPageView(page: pages[currentPage])
                .id(currentPage)
                .transition(.opacity.combined(with: .move(edge: .trailing)))

            VStack(spacing: 20) {
                OnboardingPageIndicator(pageCount: pages.count, currentPage: currentPage)

                HStack(spacing: 16) {
                    if currentPage > 0 {
                        Button("Back", action: goBack)
                            .buttonStyle(.bcOutline(color: .bcTextSecondary))
                    }

                    if currentPage < pages.count - 1 {
                        Button("Next", action: goNext)
                            .buttonStyle(.bcFilled(color: .bcAccent))
                    } else {
                        Button("Get Started", action: onFinish)
                            .buttonStyle(.bcFilled(color: .bcPositive))
                    }
                }
            }
            .padding(.bottom, 28)
        }
        .frame(width: 560, height: 480)
        .background(Color.bcBackground)
    }

    private func goNext() {
        withAnimation {
            currentPage = min(currentPage + 1, pages.count - 1)
        }
    }

    private func goBack() {
        withAnimation {
            currentPage = max(currentPage - 1, 0)
        }
    }
}

#Preview {
    OnboardingView(onFinish: {})
}
