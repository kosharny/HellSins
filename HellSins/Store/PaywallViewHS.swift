import SwiftUI
import StoreKit

struct PaywallViewHS: View {
    let theme: AppThemeHS
    @Binding var path: NavigationPath

    @StateObject private var store = StoreManagerHS.shared

    @State private var showConfirmAlert = false
    @State private var showResultAlert = false
    @State private var resultTitle = ""
    @State private var resultMessage = ""
    @State private var isSuccess = false
    @State private var selectedProduct: Product?

    var body: some View {
        ZStack {
            LinearGradient(
                colors: theme.gradient,
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    topBar
                    heroSection
                    featuresSection
                    Spacer(minLength: 32)
                    purchaseSection
                }
            }
        }
        .navigationBarHidden(true)
        .hellAlert(isPresented: $showConfirmAlert, alert: confirmAlert)
        .hellAlert(isPresented: $showResultAlert, alert: resultAlert)
        .task { if store.products.isEmpty { await store.loadProducts() } }
    }

    private var topBar: some View {
        HStack {
            Button { path.removeLast() } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white.opacity(0.5))
                    .padding(12)
                    .background(Color.white.opacity(0.1))
                    .clipShape(Circle())
            }
            Spacer()
            Text("Unlock Theme")
                .font(.system(size: 16, weight: .bold)).foregroundColor(.white)
            Spacer()
            Color.clear.frame(width: 44, height: 44)
        }
        .padding(.horizontal, 20).padding(.top, 12)
    }

    private var heroSection: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(theme.primaryColor.opacity(0.25))
                    .frame(width: 140, height: 140)
                    .blur(radius: 30)
                    .shadow(color: theme.primaryColor.opacity(0.5), radius: 30)
                Circle()
                    .fill(LinearGradient(colors: [theme.primaryColor, theme.accentColor], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 100, height: 100)
                Image(systemName: theme.previewIcon)
                    .font(.system(size: 44, weight: .bold))
                    .foregroundColor(.white)
            }
            .padding(.top, 24)

            Text(theme.displayName)
                .font(.system(size: 32, weight: .black, design: .rounded))
                .foregroundStyle(LinearGradient(colors: [.white, theme.primaryColor.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing))

            Text("Exclusive premium visual theme")
                .font(.system(size: 14, weight: .medium)).foregroundColor(.white.opacity(0.55))
        }
        .padding(.bottom, 24)
    }

    private var featuresSection: some View {
        VStack(spacing: 10) {
            featureRow(icon: "paintpalette.fill", title: "Unique Color Palette", subtitle: "Experience the app in all-new atmospheric colors")
            featureRow(icon: "sparkles", title: "Exclusive Visuals", subtitle: "Enhanced UI elements, gradients and accent glow")
            featureRow(icon: "heart.fill", title: "Support Development", subtitle: "Help us build more powerful discipline tools")
        }
        .padding(.horizontal, 20)
    }

    @ViewBuilder
    private func featureRow(icon: String, title: String, subtitle: String) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(theme.primaryColor)
                .frame(width: 44, height: 44)
                .background(theme.primaryColor.opacity(0.15))
                .clipShape(Circle())
            VStack(alignment: .leading, spacing: 3) {
                Text(title).font(.system(size: 14, weight: .semibold)).foregroundColor(.white)
                Text(subtitle).font(.system(size: 12, weight: .regular)).foregroundColor(.white.opacity(0.45))
            }
            Spacer()
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 16)).foregroundColor(Color(hex: "#30D158"))
        }
        .padding(14)
        .background(Color.white.opacity(0.06))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(theme.primaryColor.opacity(0.2), lineWidth: 0.8))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private var purchaseSection: some View {
        VStack(spacing: 12) {
            if let product = store.products.first(where: { $0.id == theme.productID }) {
                Button {
                    selectedProduct = product
                    showConfirmAlert = true
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "crown.fill").font(.system(size: 16, weight: .bold))
                        Text("Unlock for \(product.displayPrice)").font(.system(size: 16, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(LinearGradient(colors: [theme.primaryColor, theme.accentColor], startPoint: .leading, endPoint: .trailing))
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .shadow(color: theme.primaryColor.opacity(0.5), radius: 12, y: 5)
                }
                .buttonStyle(PlainButtonStyle())

                Button {
                    Task {
                        await store.restorePurchases()
                        if store.hasAccess(to: theme) {
                            resultTitle = "Restored!"
                            resultMessage = "Your purchase has been successfully restored."
                            isSuccess = true
                        } else {
                            resultTitle = "Nothing Found"
                            resultMessage = "No previous purchase found for this theme."
                            isSuccess = false
                        }
                        showResultAlert = true
                    }
                } label: {
                    Text("Restore Purchases")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.4))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                }
                .buttonStyle(PlainButtonStyle())

            } else if store.isLoading {
                ProgressView().tint(theme.primaryColor)
                Text("Loading…").font(.system(size: 13)).foregroundColor(.white.opacity(0.4))
            } else {
                Button { Task { await store.loadProducts() } } label: {
                    Label("Retry", systemImage: "arrow.clockwise")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(theme.primaryColor)
                }
                .buttonStyle(PlainButtonStyle())
            }

            Button { path.removeLast() } label: {
                Text("Not Now")
                    .font(.system(size: 13, weight: .medium)).foregroundColor(.white.opacity(0.3))
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.bottom, 32)
        }
        .padding(.horizontal, 24)
        .padding(.top, 16)
    }

    var confirmAlert: CustomAlertHS {
        CustomAlertHS(
            title: "Confirm Purchase",
            message: "Unlock \(theme.displayName) for \(selectedProduct?.displayPrice ?? theme.price)?\n\nOne-time purchase, no subscription.",
            primaryButton: .init(title: "Purchase", isPrimary: true) {
                Task { await performPurchase() }
            },
            secondaryButton: .init(title: "Cancel")
        )
    }

    var resultAlert: CustomAlertHS {
        CustomAlertHS(
            title: resultTitle,
            message: resultMessage,
            primaryButton: .init(title: "OK", isPrimary: true) {
                if isSuccess { path.removeLast() }
            },
            secondaryButton: nil
        )
    }

    func performPurchase() async {
        guard let product = selectedProduct else { return }
        let status = await store.purchase(product)
        switch status {
        case .success:
            resultTitle = "Unlocked!"
            resultMessage = "\(theme.displayName) is now active. Enjoy the new look."
            isSuccess = true
            showResultAlert = true
        case .cancelled:
            break
        case .pending:
            resultTitle = "Pending"
            resultMessage = "Your purchase is pending approval. It will activate shortly."
            isSuccess = false
            showResultAlert = true
        case .failed:
            resultTitle = "Purchase Failed"
            resultMessage = "We couldn't complete your purchase. Please try again."
            isSuccess = false
            showResultAlert = true
        }
    }
}

#Preview {
    PaywallViewHS(theme: .frozenHell, path: .constant(NavigationPath()))
}
