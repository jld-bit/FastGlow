import Foundation
import StoreKit

@MainActor
final class PurchaseManager: ObservableObject {
    @Published private(set) var isPremiumUnlocked = false
    @Published private(set) var premiumProduct: Product?

    private let premiumProductID = "com.fastglow.premium.yearly"

    func bootstrap() async {
        await loadProducts()
        await refreshEntitlements()
    }

    func loadProducts() async {
        do {
            premiumProduct = try await Product.products(for: [premiumProductID]).first
        } catch {
            print("Failed to load products: \(error)")
        }
    }

    func purchasePremium() async {
        guard let premiumProduct else { return }

        do {
            let result = try await premiumProduct.purchase()
            switch result {
            case .success(let verification):
                if case .verified = verification {
                    isPremiumUnlocked = true
                }
            default:
                break
            }
        } catch {
            print("Purchase failed: \(error)")
        }
    }

    func refreshEntitlements() async {
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else { continue }
            if transaction.productID == premiumProductID {
                isPremiumUnlocked = true
                return
            }
        }
        isPremiumUnlocked = false
    }
}
