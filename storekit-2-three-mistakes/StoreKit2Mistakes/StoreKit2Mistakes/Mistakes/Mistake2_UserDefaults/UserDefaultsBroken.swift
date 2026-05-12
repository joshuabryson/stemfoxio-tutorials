import Combine
import Foundation
import SwiftUI

/// MISTAKE #2 — BROKEN PATTERN
///
/// What Claude/ChatGPT generates by default when asked to "build a paywall in
/// SwiftUI": a `UserDefaults` flag as the source of truth for premium access.
///
/// WHY IT'S BROKEN:
///   • Apple Guideline 3.1.1 — "Apps must honor valid purchases."
///   • Scenario A — Fresh install: user reinstalls, UserDefaults wiped, premium
///     not restored. Apple's reviewer triggers this in 30 seconds.
///   • Scenario B — Cross-device: same Apple ID on a second device, valid
///     entitlement, empty UserDefaults. Reject under 3.1.1.
///   • Scenario C — Refunds / expirations: UserDefaults never gets cleared.
///     User keeps premium after a refund or after a subscription lapses. This
///     bleeds revenue post-launch even when review passes.
///
/// See `UserDefaultsFixed.swift` for the correct pattern using `Transaction.currentEntitlements`.
enum Mistake2_Broken {
    @MainActor
    final class BrokenEntitlementManager: ObservableObject {
        @Published var hasPremiumAccess: Bool

        private let key = "isPro"

        init() {
            // Local-device flag. Doesn't sync across devices, doesn't survive
            // reinstall, doesn't reflect refunds or expirations.
            hasPremiumAccess = UserDefaults.standard.bool(forKey: key)
        }

        func grantPremium() {
            // Once set, never automatically cleared on refund / expiration.
            UserDefaults.standard.set(true, forKey: key)
            hasPremiumAccess = true
        }
    }
}
