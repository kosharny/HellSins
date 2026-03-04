import SwiftUI

struct SettingsViewHS: View {
    @EnvironmentObject var vm: ViewModelHS
    @Binding var path: NavigationPath

    @StateObject private var store = StoreManagerHS.shared
    @State private var selectedThemeForPaywall: AppThemeHS? = nil
    @State private var showRestoreAlert = false
    @State private var restoreAlertTitle = ""
    @State private var restoreAlertMessage = ""

    var body: some View {
        ZStack {
            InfernoBackgroundHS()
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    topBar
                    themesSection
                    watchTutorialRow
                    aboutSection
                    Spacer(minLength: 40)
                }
            }
        }
        .navigationBarHidden(true)
        .hellAlert(
            isPresented: $showRestoreAlert,
            alert: CustomAlertHS(
                title: restoreAlertTitle,
                message: restoreAlertMessage,
                primaryButton: .init(title: "OK", isPrimary: true),
                secondaryButton: nil
            )
        )
    }

    // MARK: — Top Bar
    private var topBar: some View {
        HStack {
            Button { path.removeLast() } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(vm.currentTheme.primaryColor)
                    .padding(12)
                    .background(Color.white.opacity(0.07))
                    .clipShape(Circle())
            }
            Spacer()
            Text("Settings")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            Spacer()
            Color.clear.frame(width: 44, height: 44)
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
    }

    // MARK: — Themes (horizontal scroll of cards)
    private var themesSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            sectionHeader("THEMES", icon: "paintbrush.fill")
                .padding(.horizontal, 20)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(AppThemeHS.allCases) { theme in
                        themeCard(theme: theme)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 4)
            }

            Button {
                Task {
                    await store.restorePurchases()
                    if store.purchasedProductIDs.isEmpty {
                        restoreAlertTitle = "Nothing Found"
                        restoreAlertMessage = "No previous purchases found for this account."
                    } else {
                        restoreAlertTitle = "Restored!"
                        restoreAlertMessage = "Your premium themes have been restored."
                    }
                    showRestoreAlert = true
                }
            } label: {
                HStack(spacing: 14) {
                    ZStack {
                        Circle()
                            .fill(LinearGradient(colors: [Color(hex: "#FFD60A"), Color(hex: "#FF6A00")], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(width: 40, height: 40)
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                    }
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Restore Purchases")
                            .font(.system(size: 14, weight: .semibold)).foregroundColor(.white)
                        Text("Recover your unlocked themes")
                            .font(.system(size: 12, weight: .regular)).foregroundColor(.white.opacity(0.4))
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .semibold)).foregroundColor(.white.opacity(0.3))
                }
                .padding(14)
                .background(Color.white.opacity(0.06))
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color(hex: "#FFD60A").opacity(0.25), lineWidth: 0.8))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.horizontal, 20)

        }
    }

    @ViewBuilder
    private func themeCard(theme: AppThemeHS) -> some View {
        let isActive = vm.profile.selectedTheme == theme
        let hasAccess = store.hasAccess(to: theme)

        Button {
            if hasAccess {
                vm.selectTheme(theme)
            } else {
                path.append(NavigationDestinationHS.paywall(theme.productID))
            }
        } label: {
            VStack(alignment: .leading, spacing: 0) {
                ZStack {
                    LinearGradient(colors: theme.gradient, startPoint: .topLeading, endPoint: .bottomTrailing)
                        .frame(height: 120)

                    VStack(spacing: 8) {
                        Image(systemName: theme.previewIcon)
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.white)
                            .shadow(color: theme.primaryColor.opacity(0.6), radius: 10)
                        if !hasAccess {
                            Image(systemName: "lock.fill")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white.opacity(0.7))
                                .padding(.horizontal, 10).padding(.vertical, 4)
                                .background(Color.black.opacity(0.4)).clipShape(Capsule())
                        }
                    }
                }
                .clipShape(UnevenRoundedRectangle(topLeadingRadius: 16, topTrailingRadius: 16))

                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(theme.displayName)
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.white)
                        Spacer()
                        if isActive {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 14))
                                .foregroundColor(theme.primaryColor)
                        }
                    }
                    if theme.isPremium && !hasAccess {
                        Text(theme.price)
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(Color(hex: "#FFD60A"))
                    } else if theme.isPremium {
                        Label("Owned", systemImage: "crown.fill")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(Color(hex: "#FFD60A"))
                    } else {
                        Text("Free")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(Color(hex: "#30D158"))
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
            }
            .frame(width: 160)
            .background(Color.white.opacity(0.05))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isActive ? theme.primaryColor : Color.white.opacity(0.1), lineWidth: isActive ? 2 : 0.5)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .scaleEffect(isActive ? 1.02 : 1.0)
            .shadow(color: isActive ? theme.primaryColor.opacity(0.35) : Color.clear, radius: 12, y: 4)
            .animation(.spring(response: 0.3), value: isActive)
        }
        .buttonStyle(PlainButtonStyle())
    }

    // MARK: — Watch Tutorial (WebView)
    private var watchTutorialRow: some View {
        Button {
            path.append(NavigationDestinationHS.webView("https://www.youtube.com/watch?v=EsVnC_c9Rxk"))
        } label: {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(LinearGradient(colors: [Color(hex: "#FF3B30"), Color(hex: "#FF6A00")], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 40, height: 40)
                    Image(systemName: "play.fill")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                }
                VStack(alignment: .leading, spacing: 3) {
                    Text("Watch Tutorial")
                        .font(.system(size: 14, weight: .semibold)).foregroundColor(.white)
                    Text("Psychology of self-control · YouTube")
                        .font(.system(size: 12, weight: .regular)).foregroundColor(.white.opacity(0.4))
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold)).foregroundColor(.white.opacity(0.3))
            }
            .padding(14)
            .background(Color.white.opacity(0.06))
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color(hex: "#FF3B30").opacity(0.25), lineWidth: 0.8))
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal, 20)
    }

    // MARK: — About Section
    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("ABOUT", icon: "info.circle.fill")
                .padding(.horizontal, 20)

            CustomCardHS {
                VStack(spacing: 0) {
                    settingsRow(icon: "info.circle.fill", iconColor: vm.currentTheme.primaryColor, label: "About Hell Sins") {
                        path.append(NavigationDestinationHS.about)
                    }
                }
            }
            .environmentObject(vm)
            .padding(.horizontal, 20)
        }
    }

    // MARK: — Helpers
    @ViewBuilder
    private func sectionHeader(_ title: String, icon: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon).font(.system(size: 11, weight: .semibold)).foregroundColor(vm.currentTheme.primaryColor)
            Text(title).font(.system(size: 10, weight: .black)).foregroundColor(.white.opacity(0.35)).tracking(1.5)
        }
    }

    @ViewBuilder
    private func settingsRow(icon: String, iconColor: Color, label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(iconColor)
                    .frame(width: 36, height: 36)
                    .background(iconColor.opacity(0.12))
                    .clipShape(Circle())
                Text(label)
                    .font(.system(size: 14, weight: .medium)).foregroundColor(.white)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 11, weight: .semibold)).foregroundColor(.white.opacity(0.25))
            }
            .padding(.vertical, 6)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

extension ViewModelHS {
    func resetAll() {
        profile = UserProfileHS()
        habits = HabitModelHS.defaults
        currentMission = MissionModelHS.defaultMission
        sins = SinTypeHS.allCases.map { SinModelHS(id: $0, masteryLevel: 0, progress: 0.0) }
        dailyActivity = []
        saveAll()
    }
}

#Preview {
    SettingsViewHS(path: .constant(NavigationPath()))
        .environmentObject(ViewModelHS())
}
