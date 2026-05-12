import Foundation
import StoreKit

@MainActor
@Observable
final class EntitlementManager {
    private(set) var hasUnlockedPro = false
    private(set) var hasActiveProSubscription = false

    var hasPremiumAccess: Bool {
        hasUnlockedPro || hasActiveProSubscription
    }

    init() {
        // Mistake #1 fix (lifecycle): the Transaction.updates listener belongs
        // to a long-lived, app-owned object — NOT a view's .task that can
        // deinit. Held by @main as @State, this manager lives the full app
        // lifetime; the OS reaps the Task on app termination.
        Task { [weak self] in
            for await result in Transaction.updates {
                guard let self else { return }
                guard case .verified(let transaction) = result else {
                    continue
                }
                // Mistake #1 fix (other half): always finish the transaction.
                // Otherwise it stays pending and re-fires on every launch.
                await transaction.finish()
                await self.refreshEntitlements()
            }
        }
    }

    /// Mistake #2 fix: source of truth is `Transaction.currentEntitlements`,
    /// not `UserDefaults`. Apple-ID-bound (not device-bound). Reflects refunds
    /// (via `revocationDate`), expirations (via `expirationDate`), family
    /// sharing, and fresh installs automatically.
    func refreshEntitlements() async {
        var unlockedPro = false
        var activeSubscription = false

        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else {
                continue
            }
            if transaction.revocationDate != nil {
                continue
            }

            switch transaction.productID {
            case ProductID.unlockPro:
                unlockedPro = true
            case ProductID.proMonthly:
                if let expiration = transaction.expirationDate, expiration < .now {
                    continue
                }
                activeSubscription = true
            default:
                break
            }
        }

        hasUnlockedPro = unlockedPro
        hasActiveProSubscription = activeSubscription
    }
}
