import Foundation
import StoreKit

@MainActor
@Observable
final class EntitlementManager {
    private(set) var hasUnlockedPro = false
    private(set) var hasActiveProSubscription = false

    /// Ep 2 Ch 2: surface what the `Transaction.updates` listener just did so
    /// the UI can render it. Without this, the listener is doing real work
    /// invisibly — you can only tell it ran by checking entitlements after.
    private(set) var lastTransactionStatus: String?

    var hasPremiumAccess: Bool {
        hasUnlockedPro || hasActiveProSubscription
    }

    init() {
        Task { [weak self] in
            for await result in Transaction.updates {
                guard let self else { return }
                guard case .verified(let transaction) = result else {
                    continue
                }
                await transaction.finish()
                await self.refreshEntitlements()
                self.lastTransactionStatus = self.describe(transaction)
            }
        }
    }

    /// Ep 2 Ch 3: name what state the transaction is actually in. Forcing edge
    /// cases via Xcode's Manage Transactions window (refund / expire / upgrade)
    /// fires the listener with different transaction shapes — this read renders
    /// each path without writing branch-specific handlers in the UI layer.
    private func describe(_ transaction: Transaction) -> String {
        if transaction.revocationDate != nil {
            return "Refunded — \(transaction.productID)"
        }
        if let expiration = transaction.expirationDate, expiration < .now {
            return "Expired — \(transaction.productID)"
        }
        if transaction.isUpgraded {
            return "Upgraded — \(transaction.productID)"
        }
        if let expiration = transaction.expirationDate {
            let when = expiration.formatted(.dateTime.month().day().hour().minute())
            return "Active — \(transaction.productID) (renews \(when))"
        }
        return "Purchased — \(transaction.productID)"
    }

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
            case ProductID.proMonthly, ProductID.proAnnual:
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
