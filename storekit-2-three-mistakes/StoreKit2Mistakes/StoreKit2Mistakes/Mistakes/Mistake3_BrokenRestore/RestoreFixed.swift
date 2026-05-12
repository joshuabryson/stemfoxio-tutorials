import Foundation
import StoreKit
import SwiftUI

/// MISTAKE #3 — FIXED PATTERN
///
/// "Restore Purchases" is just "re-read what the user already owns." The cheap,
/// correct, instant answer is to iterate `Transaction.currentEntitlements` —
/// the same source of truth that powers every other premium-state check.
///
/// `AppStore.sync()` is NOT the default action. It's the **escalation**:
/// reserved for the case where the cheap read genuinely came up empty and we
/// have a real reason to suspect the local cache is wrong (signed-out App
/// Store account, fresh install on a new device whose receipt hasn't synced
/// yet, recent Apple ID switch). Only then does it earn its cost — auth
/// prompt, network round-trip, rate limit.
///
/// The pattern:
///   1. Refresh from `Transaction.currentEntitlements`. Done? Stop.
///   2. Still empty? Now call `AppStore.sync()`.
///   3. Refresh again from `currentEntitlements` and report the outcome.
enum Mistake3_Fixed {
    enum RestoreOutcome {
        case restored
        case nothingFound
        case failed(Error)
    }

    @MainActor
    static func restorePurchases(into manager: EntitlementManager) async -> RestoreOutcome {
        // Step 1 — cheap read. No auth prompt, no network. If anything is
        // owned, we'll see it here. This is the path that handles 99% of
        // taps: a paying user on their own device just confirming state.
        await manager.refreshEntitlements()
        if manager.hasPremiumAccess {
            return .restored
        }

        // Step 2 — escalate. Empty entitlements after a Restore tap means
        // the local StoreKit cache disagrees with reality. Most common
        // causes: user is signed out of the App Store, the device is fresh
        // and hasn't synced its receipt yet, or they've switched Apple IDs.
        // `AppStore.sync()` prompts auth and forces the cache to refresh.
        // It is the right tool ONLY at this point — never as the default.
        do {
            try await AppStore.sync()
        } catch {
            return .failed(error)
        }

        // Step 3 — re-read the source of truth. Whatever sync pulled down
        // (or didn't) is now reflected in `currentEntitlements`.
        await manager.refreshEntitlements()
        return manager.hasPremiumAccess ? .restored : .nothingFound
    }
}
