import Foundation
import StoreKit

/// MISTAKE #2 — FIXED PATTERN
///
/// `Transaction.currentEntitlements` is the source of truth for what the user
/// owns. It's Apple-ID-bound (not device-bound), reflects refunds via
/// `revocationDate`, reflects subscription expirations via `expirationDate`,
/// and works automatically across devices, fresh installs, and family sharing.
///
/// In the live app this pattern lives in `EntitlementManager.swift`. This file
/// is here as a focused reference for the teaching.
enum Mistake2_Fixed {
    @MainActor
    static func computePremium(productIDs: Set<String>) async -> Bool {
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else { continue }
            guard productIDs.contains(transaction.productID) else { continue }

            // Refunded — skip.
            if transaction.revocationDate != nil { continue }
            // Subscription that's already expired — skip.
            if let expiration = transaction.expirationDate, expiration < .now { continue }

            return true
        }
        return false
    }
}
