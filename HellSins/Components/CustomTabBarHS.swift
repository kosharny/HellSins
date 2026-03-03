import SwiftUI

struct CustomTabBarHS: View {
    @EnvironmentObject var vm: ViewModelHS

    struct TabItemHS {
        let icon: String
        let label: String
    }

    let tabs: [TabItemHS] = [
        TabItemHS(icon: "flame.fill", label: "Inferno"),
        TabItemHS(icon: "shield.fill", label: "Trial"),
        TabItemHS(icon: "moon.fill", label: "Penance"),
        TabItemHS(icon: "book.fill", label: "Library"),
        TabItemHS(icon: "crown.fill", label: "Judgement")
    ]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(tabs.enumerated()), id: \.offset) { index, tab in
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        vm.selectTab(index)
                    }
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: tab.icon)
                            .font(.system(size: vm.selectedTab == index ? 20 : 17, weight: .semibold))
                            .foregroundStyle(
                                vm.selectedTab == index
                                    ? LinearGradient(colors: [vm.currentTheme.primaryColor, vm.currentTheme.accentColor], startPoint: .top, endPoint: .bottom)
                                    : LinearGradient(colors: [Color.white.opacity(0.35), Color.white.opacity(0.35)], startPoint: .top, endPoint: .bottom)
                            )
                            .scaleEffect(vm.selectedTab == index ? 1.1 : 1.0)

                        Text(tab.label)
                            .font(.system(size: 9, weight: .semibold))
                            .foregroundColor(vm.selectedTab == index ? vm.currentTheme.primaryColor : Color.white.opacity(0.3))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.horizontal, 8)
        .background(
            ZStack {
                Color(hex: "#0F0F12").opacity(0.85)
                vm.currentTheme.primaryColor.opacity(0.06)
            }
        )
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .stroke(Color.white.opacity(0.1), lineWidth: 0.8)
        )
        .shadow(color: Color.black.opacity(0.4), radius: 20, y: 8)
        .shadow(color: vm.currentTheme.primaryColor.opacity(0.15), radius: 12, y: 4)
    }
}

#Preview {
    ZStack {
        Color(hex: "#0F0F12").ignoresSafeArea()
        VStack {
            Spacer()
            CustomTabBarHS()
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
        }
    }
    .environmentObject(ViewModelHS())
}
