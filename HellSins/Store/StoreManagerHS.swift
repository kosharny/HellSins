import Combine
import StoreKit
import SwiftUI

@MainActor
final class StoreManagerHS: ObservableObject {
    static let shared = StoreManagerHS()

    @Published var products: [Product] = []
    @Published var purchasedProductIDs: Set<String> = [] {
        didSet {
            UserDefaults.standard.set(Array(purchasedProductIDs), forKey: "hellsins.purchasedIDs")
        }
    }
    @Published var isLoading = false
    @Published var entitlementsLoaded = false
    @Published var pendingPurchaseIntent: PurchaseIntent?

    private let productIDs: Set<String> = [
        StoreManagerHS.frozenHellID,
        StoreManagerHS.voidAbyssID
    ]

    static let frozenHellID = "premium_theme_frozenhell"
    static let voidAbyssID  = "premium_theme_voidabyss"
    static let allProductIDs: [String] = [frozenHellID, voidAbyssID]
    private let cacheKey = "hellsins.purchasedIDs"

    var hasPurchasedAllThemes: Bool {
        productIDs.isSubset(of: purchasedProductIDs)
    }

    init() {
        if let cached = UserDefaults.standard.array(forKey: "hellsins.purchasedIDs") as? [String] {
            purchasedProductIDs = Set(cached)
        }
        Task {
            await fetchProducts()
            await updatePurchasedProducts()
        }
        Task { await observeTransactions() }
        Task { await listenForStoreIntents() }
    }


    func fetchProducts() async {
        isLoading = true
        do {
            let fetched = try await Product.products(for: productIDs)
            products = fetched
        } catch {}
        isLoading = false
    }

    func loadProducts() async {
        await fetchProducts()
    }

    func purchase(_ product: Product) async -> PurchaseStatus {
        do {
            let result = try await product.purchase()
            return try await handlePurchaseResult(result)
        } catch {
            return .failed
        }
    }

    func purchaseWithPromotionalOffer(
        product: Product,
        offerID: String,
        keyID: String,
        nonce: UUID,
        signature: Data,
        timestamp: Int
    ) async -> PurchaseStatus {
        guard let subscription = product.subscription,
              subscription.promotionalOffers.first(where: { $0.id == offerID }) != nil else {
            return .failed
        }
        let option = Product.PurchaseOption.promotionalOffer(
            offerID: offerID,
            keyID: keyID,
            nonce: nonce,
            signature: signature,
            timestamp: timestamp
        )
        do {
            let result = try await product.purchase(options: [option])
            return try await handlePurchaseResult(result)
        } catch {
            return .failed
        }
    }

    func restorePurchases() async {
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result {
                purchasedProductIDs.insert(transaction.productID)
            }
        }
    }

    func restore() async {
        await restorePurchases()
    }

    func isPurchased(_ productID: String) -> Bool {
        purchasedProductIDs.contains(productID)
    }

    func hasAccess(to theme: AppThemeHS) -> Bool {
        guard theme.isPremium else { return true }
        return purchasedProductIDs.contains(theme.productID)
    }

    func product(for theme: AppThemeHS) -> Product? {
        products.first { $0.id == theme.productID }
    }

    private func handlePurchaseResult(_ result: Product.PurchaseResult) async throws -> PurchaseStatus {
        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            purchasedProductIDs.insert(transaction.productID)
            await transaction.finish()
            return .success
        case .userCancelled:
            return .cancelled
        case .pending:
            return .pending
        @unknown default:
            return .failed
        }
    }

    private func updatePurchasedProducts() async {
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result {
                purchasedProductIDs.insert(transaction.productID)
            }
        }
        entitlementsLoaded = true
    }

    private func observeTransactions() async {
        for await result in Transaction.updates {
            if case .verified(let transaction) = result {
                purchasedProductIDs.insert(transaction.productID)
                await transaction.finish()
            }
        }
    }

    private func listenForStoreIntents() async {
        if #available(iOS 16.4, *) {
            for await intent in PurchaseIntent.intents {
                pendingPurchaseIntent = intent
                _ = await purchase(intent.product)
            }
        }
    }

    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .verified(let safe): return safe
        case .unverified: throw StoreError.failedVerification
        }
    }
}

enum StoreError: Error {
    case failedVerification
}

enum PurchaseStatus {
    case success, pending, cancelled, failed
}
