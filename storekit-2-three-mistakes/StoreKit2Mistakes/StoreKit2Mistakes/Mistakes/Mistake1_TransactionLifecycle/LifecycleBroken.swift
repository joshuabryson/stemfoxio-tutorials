import Foundation
import StoreKit
import SwiftUI

/// MISTAKE #1 — BROKEN PATTERN
///
/// What you'll find in many StoreKit 2 tutorials and AI-generated paywalls:
/// the `Transaction.updates` listener is started inside a view's `.task`, and
/// transactions are never explicitly finished.
///
/// This view also leans on the **Mistake #2** broken pattern — a UserDefaults
/// flag (`Mistake2_Broken.BrokenEntitlementManager`) as its source of truth
/// for premium access. The two mistakes compound: even if Apple later fires a
/// renewal or revocation through `Transaction.updates`, this view's listener
/// won't see it (Mistake #1a), and even if it did, the UserDefaults flag never
/// reflects refunds/expirations (Mistake #2). It's the AI-generated paywall
/// in microcosm.
///
/// WHY MISTAKE #1 IS BROKEN:
///  1. Views can deinit. When the user navigates away, `.task` is cancelled and
///     the listener stops. Subscription renewals, family-sharing entitlements,
///     and ask-to-buy approvals (which can arrive *days* later) get missed.
///  2. Without `await transaction.finish()`, transactions stay in a pending
///     state. They re-fire on every app launch, can show up as duplicate
///     purchases, and can flag the app under Apple Guideline 2.1.
///
/// The view below is intentionally a complete, runnable paywall — products
/// load, the buttons work, the purchase sheet appears. It looks fine in the
/// simulator. App Review is where the bill comes due.
///
/// See `LifecycleFixed.swift` for the correct lifecycle pattern, and
/// `EntitlementManager.swift` (live) for the correct source-of-truth pattern.
enum Mistake1_Broken {
    struct BrokenPaywallView: View {
        @StateObject private var entitlements = Mistake2_Broken.BrokenEntitlementManager()
        @Environment(\.dismiss) private var dismiss

        @State private var products: [Product] = []
        @State private var purchaseInProgress = false
        @State private var errorMessage: String?

        var body: some View {
            NavigationStack {
                ScrollView {
                    VStack(spacing: 24) {
                        headerCard

                        if products.isEmpty {
                            ProgressView("Loading products…")
                                .padding()
                        } else {
                            ForEach(products, id: \.id) { product in
                                productCard(product)
                            }
                        }

                        Button("Restore Purchases", action: restore)
                            .buttonStyle(.bordered)
                            .padding(.top, 8)

                        if let errorMessage {
                            Text(errorMessage)
                                .font(.caption)
                                .foregroundStyle(.red)
                                .padding(.horizontal)
                        }
                    }
                    .padding()
                }
                .navigationTitle("X-Men Pro")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Done") { dismiss() }
                    }
                }
                .task {
                    await loadProducts()

                    // 🚨 MISTAKE #1a — listener attached to a view's `.task`.
                    // The moment this view deinits (user dismisses the sheet,
                    // pops the nav stack, switches tabs), SwiftUI cancels this
                    // `.task` and the listener dies. Renewals, ask-to-buy
                    // approvals, and family-sharing grants that arrive after
                    // that point are silently dropped.
                    for await result in Transaction.updates {
                        if case .verified(let transaction) = result {
                            // 🚨 MISTAKE #1b — no `await transaction.finish()`.
                            // The transaction stays pending, re-fires on every
                            // launch, and can flag the app under Guideline 2.1.
                            print("Got transaction \(transaction.id)")
                            // 🚨 MISTAKE #2 (compounded) — flips the
                            // UserDefaults flag instead of reading
                            // `Transaction.currentEntitlements`. Won't reflect
                            // future revocations or expirations.
                            entitlements.grantPremium()
                        }
                    }
                }
            }
        }

        private var headerCard: some View {
            VStack(spacing: 8) {
                Image(systemName: "crown.fill")
                    .font(.system(size: 56))
                    .foregroundStyle(.yellow)
                Text("Unlock the full roster")
                    .font(.title2.bold())
                Text("Unlimited teams. Saved lineups. Advanced stats.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
        }

        private func productCard(_ product: Product) -> some View {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(product.displayName).font(.headline)
                        Text(product.description).font(.caption).foregroundStyle(.secondary)
                    }
                    Spacer()
                    Text(product.displayPrice).font(.title3.bold())
                }
                Button {
                    Task { await purchase(product) }
                } label: {
                    Text(callToAction(product))
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(purchaseInProgress || entitlements.hasPremiumAccess)
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 16).fill(Color(.secondarySystemBackground)))
        }

        private func callToAction(_ product: Product) -> String {
            if entitlements.hasPremiumAccess { return "Active" }
            return product.type == .autoRenewable ? "Subscribe" : "Unlock"
        }

        @MainActor
        private func loadProducts() async {
            do {
                let loaded = try await Product.products(for: ProductID.all)
                products = loaded.sorted { lhs, rhs in
                    lhs.type == .autoRenewable && rhs.type != .autoRenewable
                }
            } catch {
                errorMessage = "Couldn't load products: \(error.localizedDescription)"
            }
        }

        @MainActor
        private func purchase(_ product: Product) async {
            purchaseInProgress = true
            defer { purchaseInProgress = false }

            do {
                let result = try await product.purchase()
                switch result {
                case .success(let verification):
                    guard case .verified = verification else {
                        errorMessage = "Purchase couldn't be verified."
                        return
                    }
                    // 🚨 MISTAKE #1b (again) — the purchase path also skips
                    // `await transaction.finish()`. A correct paywall finishes
                    // here AND in the listener; this one finishes nowhere.
                    // 🚨 MISTAKE #2 — flips the UserDefaults flag as the
                    // grant. Future refunds/expirations won't be reflected.
                    entitlements.grantPremium()
                case .userCancelled, .pending:
                    break
                @unknown default:
                    break
                }
            } catch {
                errorMessage = error.localizedDescription
            }
        }

        // 🚨 MISTAKE #3 (preview) — "Restore" does nothing useful in this
        // broken flow. UserDefaults is local; there's nothing to refresh from
        // Apple. The other AI-generated alternative is `AppStore.sync()`,
        // which prompts auth and is the wrong API for this button — see
        // `RestoreBroken.swift`.
        private func restore() {
            // No-op. UserDefaults is already loaded in the manager's init.
        }
    }
}

#Preview {
    Mistake1_Broken.BrokenPaywallView()
}
