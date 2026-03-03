import SwiftUI

struct AboutViewHS: View {
    @EnvironmentObject var vm: ViewModelHS
    @Binding var path: NavigationPath

    var body: some View {
        ZStack {
            InfernoBackgroundHS()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    HStack {
                        Button {
                            path.removeLast()
                        } label: {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(vm.currentTheme.primaryColor)
                                .padding(12)
                                .background(Color.white.opacity(0.07))
                                .clipShape(Circle())
                        }
                        Spacer()
                        Text("About")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        Spacer()
                        Color.clear.frame(width: 44, height: 44)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)

                    ZStack {
                        Circle()
                            .fill(vm.currentTheme.primaryColor.opacity(0.12))
                            .frame(width: 100, height: 100)
                        Image("mainLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 250, height: 250)
                    }

                    VStack(spacing: 6) {
                        Text("Hell Sins")
                            .font(.system(size: 28, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                        Text("Version 1.0.0")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.4))
                    }

                    CustomCardHS {
                        VStack(alignment: .leading, spacing: 12) {
                            Label("About the App", systemImage: "info.circle.fill")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(vm.currentTheme.primaryColor)
                                .tracking(1)
                            Text("Hell Sins is a behavioral self-control app inspired by the metaphor of the 7 deadly sins. Use it to understand your behavioral patterns, build discipline habits, and take back control of your impulses.")
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(.white.opacity(0.75))
                                .lineSpacing(5)
                        }
                    }
                    .environmentObject(vm)
                    .padding(.horizontal, 20)

                    Text("Made with 🔥 for those who seek control")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white.opacity(0.25))
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 40)
                }
            }
        }
        .navigationBarHidden(true)
    }

    @ViewBuilder
    private func aboutRow(icon: String, iconColor: Color, title: String, subtitle: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(iconColor)
                    .frame(width: 36, height: 36)
                    .background(iconColor.opacity(0.15))
                    .clipShape(Circle())
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                    Text(subtitle)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.white.opacity(0.4))
                }
                Spacer()
                Image(systemName: "arrow.up.right")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.white.opacity(0.25))
            }
            .padding(.vertical, 6)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    AboutViewHS(path: .constant(NavigationPath()))
        .environmentObject(ViewModelHS())
}
