import SwiftUI
import AppTrackingTransparency

struct SplashViewHS: View {
    @EnvironmentObject var vm: ViewModelHS
    @State private var scale: CGFloat = 0.7
    @State private var opacity: Double = 0
    @State private var loadingProgress: CGFloat = 0.0
    @State private var showApp = false

    var body: some View {
        ZStack {
            InfernoBackgroundHS()

            VStack(spacing: 20) {
                ZStack {
                    Circle()
                        .fill(Color(hex: "#FF3B30").opacity(0.15))
                        .frame(width: 140, height: 140)
                        .blur(radius: 30)

                    Image("mainLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 250)
                }

                VStack(spacing: 6) {
                    Text("HELL SINS")
                        .font(.system(size: 36, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .tracking(4)

                    Text("Master Your Inner Fire")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.5))
                        .tracking(1)
                }

                Spacer().frame(height: 50)

                VStack(spacing: 12) {
                    Text("Loading... \(Int(loadingProgress * 100))%")
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundColor(vm.currentTheme.primaryColor)
                        .contentTransition(.numericText())

                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Capsule().fill(Color.white.opacity(0.1))
                            Capsule()
                                .fill(LinearGradient(colors: [vm.currentTheme.primaryColor, vm.currentTheme.accentColor], startPoint: .leading, endPoint: .trailing))
                                .frame(width: max(0, geo.size.width * loadingProgress))
                        }
                    }
                    .frame(width: 200, height: 6)
                }
                .opacity(opacity)

            }
            .scaleEffect(scale)
            .opacity(opacity)
        }
        .onAppear {
            withAnimation(.spring(response: 0.7, dampingFraction: 0.7)) {
                scale = 1.0
                opacity = 1.0
            }

            withAnimation(.easeInOut(duration: 1.5).delay(0.2)) {
                loadingProgress = 1.0
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                ATTrackingManager.requestTrackingAuthorization { _ in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            showApp = true
                        }
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $showApp) {
            if vm.profile.onboardingDone {
                MainTabHostHS()
                    .environmentObject(vm)
            } else {
                OnboardingViewHS()
                    .environmentObject(vm)
            }
        }
    }
}

#Preview {
    SplashViewHS()
        .environmentObject(ViewModelHS())
}
