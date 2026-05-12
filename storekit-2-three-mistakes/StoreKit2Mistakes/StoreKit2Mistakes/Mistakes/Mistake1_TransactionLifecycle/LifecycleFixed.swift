import Foundation
import StoreKit
import SwiftUI

/// MISTAKE #1 — FIXED PATTERN
///
/// The transaction listener belongs to a long-lived object owned by your `@main`
/// `App`, NOT to a view's `.task`. This survives view churn and runs for the
/// entire app lifetime.
///
/// Every received transaction is explicitly finished — Apple won't otherwise
/// consider it "delivered," and it'll re-fire on the next app launch.
///
/// In the live app this pattern lives in `EntitlementManager.swift`. This file
/// is here as a focused reference for the teaching.
enum Mistake1_Fixed {
    @MainActor
    final class FixedTransactionListener {
        init() {
            // Listener is attached to an app-lived object. Stays alive as long
            // as this manager exists — which (when held by @main as @State)
            // is the entire app lifetime; the OS reaps the Task on termination.
            Task { [weak self] in
                for await result in Transaction.updates {
                    guard self != nil else { return }
                    guard case .verified(let transaction) = result else { continue }

                    // Always finish the transaction.
                    await transaction.finish()

                    // (In real code, also re-read currentEntitlements here.
                    //  See EntitlementManager.refreshEntitlements().)
                }
            }
        }
    }
}
