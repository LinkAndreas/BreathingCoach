import SwiftUI

struct OnboardingPageView: View {
    let page: OnboardingPage

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            ZStack {
                Circle()
                    .fill(Color.bcAccent.opacity(0.12))
                    .frame(width: 120, height: 120)
                Image(systemName: page.systemImage)
                    .font(.system(size: 44, weight: .medium))
                    .foregroundStyle(Color.bcAccent)
            }

            VStack(spacing: 10) {
                Text(page.title)
                    .font(.title.weight(.bold))
                    .foregroundStyle(Color.bcTextPrimary)
                    .multilineTextAlignment(.center)
                Text(page.message)
                    .font(.body)
                    .foregroundStyle(Color.bcTextSecondary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 380)
            }

            Spacer()
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 32)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    OnboardingPageView(page: OnboardingPage.all[0])
        .frame(width: 520, height: 420)
        .background(Color.bcBackground)
}
