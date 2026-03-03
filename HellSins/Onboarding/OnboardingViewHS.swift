import SwiftUI
import StoreKit

struct OnboardingViewHS: View {
    @EnvironmentObject var vm: ViewModelHS
    @State private var currentPage = 0
    @State private var animateContent = false

    struct OnboardingPageData {
        let title: String
        let subtitle: String
        let gradientColors: [Color]
        let icon: String
        let imageName: String
    }

    let pages: [OnboardingPageData] = [
        OnboardingPageData(
            title: "Master Your\nInner Fire",
            subtitle: "Your weaknesses are not enemies. They are patterns.",
            gradientColors: [Color(hex: "#0F0F12"), Color(hex: "#5C0000"), Color(hex: "#FF3B30")],
            icon: "flame.fill",
            imageName: "onboarding_slide1_hell"
        ),
        OnboardingPageData(
            title: "Face the\nSeven Sins",
            subtitle: "Discover your impulsivity, procrastination and hidden triggers.",
            gradientColors: [Color(hex: "#0F0F12"), Color(hex: "#2D0000"), Color(hex: "#FF6A00")],
            icon: "shield.fill",
            imageName: "onboarding_slide2_sins"
        ),
        OnboardingPageData(
            title: "Discipline\nBuilds Power",
            subtitle: "Small daily victories reshape your behavior.",
            gradientColors: [Color(hex: "#0F0F12"), Color(hex: "#1A0000"), Color(hex: "#FFD60A")],
            icon: "bolt.fill",
            imageName: "onboarding_slide3_discipline"
        ),
        OnboardingPageData(
            title: "Enter the\nInferno",
            subtitle: "The path to control starts now.",
            gradientColors: [Color(hex: "#0F0F12"), Color(hex: "#3D0000"), Color(hex: "#FF3B30")],
            icon: "crown.fill",
            imageName: "onboarding_slide4_begin"
        )
    ]

    var body: some View {
        ZStack {
            Color(hex: "#0F0F12").ignoresSafeArea()

            GeometryReader { geo in
                ZStack(alignment: .top) {
                    Image(pages[currentPage].imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geo.size.width, height: geo.size.height * 0.72)
                        .clipped()
                        .animation(.easeInOut(duration: 0.5), value: currentPage)

                    LinearGradient(
                        colors: [
                            Color.black.opacity(0.35),
                            pages[currentPage].gradientColors[1].opacity(0.55),
                            Color(hex: "#0F0F12")
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: geo.size.height * 0.72)
                    .animation(.easeInOut(duration: 0.6), value: currentPage)
                }
                .frame(width: geo.size.width)
            }
            .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                VStack(spacing: 0) {
                    Rectangle()
                        .fill(Color.white.opacity(0.05))
                        .frame(height: 0.5)

                    VStack(alignment: .leading, spacing: 16) {
                        HStack(spacing: 8) {
                            ForEach(0..<pages.count, id: \.self) { index in
                                Capsule()
                                    .fill(index == currentPage ? Color(hex: "#FF3B30") : Color.white.opacity(0.3))
                                    .frame(width: index == currentPage ? 24 : 8, height: 4)
                                    .animation(.spring(response: 0.4), value: currentPage)
                            }
                            Spacer()
                        }
                        .padding(.top, 24)

                        Text(pages[currentPage].title)
                            .font(.system(size: 34, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .lineSpacing(2)
                            .opacity(animateContent ? 1 : 0)
                            .offset(y: animateContent ? 0 : 20)
                            .animation(.easeOut(duration: 0.5).delay(0.1), value: animateContent)

                        Text(pages[currentPage].subtitle)
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.white.opacity(0.7))
                            .lineSpacing(4)
                            .opacity(animateContent ? 1 : 0)
                            .offset(y: animateContent ? 0 : 20)
                            .animation(.easeOut(duration: 0.5).delay(0.2), value: animateContent)

                        Button {
                            handleContinue()
                        } label: {
                            HStack {
                                Text(currentPage == pages.count - 1 ? "Enter the Inferno" : "Continue")
                                    .font(.system(size: 17, weight: .bold))
                                    .foregroundColor(.white)
                                Spacer()
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            .padding(.horizontal, 24)
                            .padding(.vertical, 18)
                            .background(
                                LinearGradient(
                                    colors: [Color(hex: "#FF3B30"), Color(hex: "#FF6A00")],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                            .shadow(color: Color(hex: "#FF3B30").opacity(0.5), radius: 12, y: 6)
                        }
                        .padding(.top, 8)
                        .padding(.bottom, 40)
                    }
                    .padding(.horizontal, 28)
                    .background(Color(hex: "#0F0F12").opacity(0.9))
                }
            }
        }

        .onAppear {
            animateContent = true
        }
        .onChange(of: currentPage) { newPage in
            if newPage == 2 {
                requestReview()
            }
        }
    }

    private func handleContinue() {
        withAnimation {
            animateContent = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            if currentPage < pages.count - 1 {
                currentPage += 1
                withAnimation { animateContent = true }
            } else {
                vm.profile.onboardingDone = true
                vm.saveAll()
            }
        }
    }

    private func requestReview() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }
}

#Preview {
    OnboardingViewHS()
        .environmentObject(ViewModelHS())
}
