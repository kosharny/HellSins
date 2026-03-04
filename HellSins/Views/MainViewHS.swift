import SwiftUI

struct MainViewHS: View {
    @EnvironmentObject var vm: ViewModelHS
    @EnvironmentObject var store: StoreManagerHS

    var body: some View {
        SplashViewHS()
    }
}

struct MainTabHostHS: View {
    @EnvironmentObject var vm: ViewModelHS
    @EnvironmentObject var store: StoreManagerHS
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            tabLayout
                .navigationDestination(for: NavigationDestinationHS.self) { destination in
                    switch destination {
                    case .settings:
                        SettingsViewHS(path: $path)
                    case .sinDetail(let sinType):
                        SinDetailViewHS(sinType: sinType, path: $path)
                    case .grounding:
                        GroundingViewHS(path: $path)
                    case .breathing:
                        BreathingViewHS(path: $path)
                    case .coldShock:
                        ColdShockViewHS(path: $path)
                    case .paywall(let productID):
                        if let theme = AppThemeHS.allCases.first(where: { $0.productID == productID }) {
                            PaywallViewHS(theme: theme, path: $path)
                        }
                    case .webView(let urlString):
                        WebContainerViewHS(urlString: urlString, path: $path)
                    case .about:
                        AboutViewHS(path: $path)
                    case .libraryDetail:
                        EmptyView()
                    }
                }
        }
    }

    private var tabLayout: some View {
        ZStack(alignment: .bottom) {
            TabContentHS(path: $path)
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            CustomTabBarHS()
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                .ignoresSafeArea(edges: .bottom)
        }
        .background(
            InfernoBackgroundHS()
                .ignoresSafeArea()
                .environmentObject(vm)
        )
        .ignoresSafeArea(edges: .bottom)
        .navigationBarHidden(true)
    }
}

struct TabContentHS: View {
    @EnvironmentObject var vm: ViewModelHS
    @Binding var path: NavigationPath

    var body: some View {
        Group {
            switch vm.selectedTab {
            case 0: InfernoViewHS(path: $path)
            case 1: TrialViewHS(path: $path)
            case 2: PenanceViewHS(path: $path)
            case 3: LibraryViewHS(path: $path)
            case 4: JudgementViewHS(path: $path)
            default: InfernoViewHS(path: $path)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    MainViewHS()
        .environmentObject(ViewModelHS())
        .environmentObject(StoreManagerHS())
}
