import SwiftUI
import StoreKit

struct PaywallView: View {
    @Environment(EntitlementManager.self) private var entitlements
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
            .navigationTitle("Pro")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
            .task {
                await loadProducts()
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
                Text(productCallToAction(product))
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(purchaseInProgress || isAlreadyOwned(product))
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 16).fill(Color(.secondarySystemBackground)))
    }

    private func productCallToAction(_ product: Product) -> String {
        if isAlreadyOwned(product) { return "Active" }
        return product.type == .autoRenewable ? "Subscribe" : "Unlock"
    }

    private func isAlreadyOwned(_ product: Product) -> Bool {
        switch product.id {
        case ProductID.unlockPro: return entitlements.hasUnlockedPro
        case ProductID.proMonthly, ProductID.proAnnual: return entitlements.hasActiveProSubscription
        default: return false
        }
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
                guard case .verified(let transaction) = verification else {
                    errorMessage = "Purchase couldn't be verified."
                    return
                }
                // Mistake #1 fix (also done in the listener; safe to do twice).
                await transaction.finish()
                await entitlements.refreshEntitlements()
            case .userCancelled, .pending:
                break
            @unknown default:
                break
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    /// Mistake #3 fix: Restore Purchases iterates `Transaction.currentEntitlements`,
    /// it does NOT call `AppStore.sync()` — sync prompts auth, takes time, and is
    /// the wrong API for this button. Same source of truth, instant, silent.
    private func restore() {
        Task {
            await entitlements.refreshEntitlements()
        }
    }
}

#Preview {
    PaywallView()
        .environment(EntitlementManager())
}
