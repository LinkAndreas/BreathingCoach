import SwiftUI

/// The first-run introduction, presented as a sheet and replayable from Settings.
///
/// The last page is also where demo mode is offered: it is the moment someone learns the app needs
/// a capnograph, so it is the moment to say they can try it without one.
struct OnboardingView: View {
    let onFinish: Action
    /// Finishes onboarding with demo mode switched on.
    let onFinishWithDemo: Action

    @State private var currentPage = 0
    @State private var demoMode = DemoMode.shared

    private let pages = OnboardingPage.all

    private var isLastPage: Bool { currentPage == pages.count - 1 }

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

                if isLastPage, !demoMode.isEnabled {
                    demoOffer
                }

                HStack(spacing: 16) {
                    if currentPage > 0 {
                        Button("Back", action: goBack)
                            .buttonStyle(.bcOutline(color: .bcTextSecondary))
                    }

                    if isLastPage {
                        Button("Get Started", action: onFinish)
                            .buttonStyle(.bcFilled(color: .bcPositive))
                    } else {
                        Button("Next", action: goNext)
                            .buttonStyle(.bcFilled(color: .bcAccent))
                    }
                }
            }
            .padding(.bottom, 28)
        }
        // Tall enough that the last page still fits its copy with the demo offer below it.
        .frame(width: 560, height: 540)
        .background(Color.bcBackground)
        .presentationBackground(Color.bcBackground)
    }

    /// The way in for someone who has no capnograph and would otherwise stop at the Connect screen.
    private var demoOffer: some View {
        VStack(spacing: 8) {
            Text("No capnograph? Try the app on simulated readings.")
                .font(.caption)
                .foregroundStyle(Color.bcTextTertiary)

            Button("Start in Demo Mode", action: onFinishWithDemo)
                .buttonStyle(.bcOutline(color: .bcWarning))
        }
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
    OnboardingView(onFinish: {}, onFinishWithDemo: {})
}
