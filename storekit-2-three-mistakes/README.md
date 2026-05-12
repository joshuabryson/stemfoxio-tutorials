# StoreKit 2: Three Mistakes Apple Rejects

Code companion for **Episode 1 of *StoreKit 2: Ship It Right*** on the [StemFoxIO YouTube channel](https://www.youtube.com/@StemFoxIO).

In this episode we walk three specific StoreKit 2 mistakes that get iOS apps rejected by Apple — the same three mistakes AI-generated paywalls make by default — and how to fix them with `Transaction.currentEntitlements` and a properly-placed `Transaction.updates` listener.

## Watch the video

📺 _Apple Will Reject Your App for These 3 StoreKit 2 Mistakes_ — link will be filled when published.

## What's in this project

A minimal SwiftUI app — an X-Men Team Builder — wired up with StoreKit 2 the *correct* way. Free tier supports 3-hero teams; the paywall offers a non-consumable IAP (**X-Men Pro**) and a monthly subscription (**Charles Xavier's Membership**).

```
StoreKit2Mistakes/
├── StoreKit2MistakesApp.swift     ← @main with EntitlementManager (fixed lifecycle)
├── ContentView.swift              ← X-Men team builder with premium gating
├── PaywallView.swift              ← IAP UI with proper Restore Purchases
├── EntitlementManager.swift       ← source of truth: listens to Transaction.updates,
│                                    reads Transaction.currentEntitlements
├── Models/
│   ├── Hero.swift                 ← X-Men sample data
│   └── ProductIDs.swift           ← centralized product IDs
├── Mistakes/
│   ├── Mistake1_TransactionLifecycle/    LifecycleBroken.swift + LifecycleFixed.swift
│   ├── Mistake2_UserDefaults/            UserDefaultsBroken.swift + UserDefaultsFixed.swift
│   └── Mistake3_BrokenRestore/           RestoreBroken.swift + RestoreFixed.swift
└── Products.storekit              ← StoreKit configuration with both products
```

The **live app** uses the FIXED patterns everywhere. The **`Mistakes/` folder** is reference material — each broken pattern is preserved in its `*Broken.swift` file so you can `cmd+click` to see what AI/tutorials get wrong, side-by-side with the fixed version.

## Getting it running

1. Open `StoreKit2Mistakes.xcodeproj` (inside `StoreKit2Mistakes/`).
2. **Select the StoreKit configuration**: Edit Scheme → Run → Options → StoreKit Configuration → choose `Products.storekit`.
3. Build and run on the simulator.
4. The paywall is reachable from the crown icon in the top-right of the home screen.

## The three mistakes

1. **The Transaction Lifecycle** — `Transaction.updates` listener belongs in your `@main` App (not a view's `.task`), and every transaction needs `await transaction.finish()`. Apple Guideline 2.1 catches this.
2. **`UserDefaults` vs `Transaction.currentEntitlements`** — the AI-wave signature mistake. `currentEntitlements` is the source of truth: Apple-ID-bound, reflects refunds and expirations automatically, works on fresh installs and across devices. Apple Guideline 3.1.1 catches this.
3. **`AppStore.sync()` for Restore Purchases** — wrong API. Restore = iterate `currentEntitlements`. No password prompt, no delay, no failure modes. Apple Guideline 3.1.1 catches this too.

## What's next in the series

- **Episode 2 — Test Every Error State with `.storekit` Files**
- **Episode 3 — Automated UI Testing for StoreKit 2**
- **Episode 4 — Server-Side Receipt Validation**

## Requirements

- Xcode 16.0+
- iOS 17.0+ (uses `@Observable`)
- Swift 5.9+

---

Made by [Joshua Bryson](https://www.youtube.com/@StemFoxIO) for [StemFoxIO](https://www.youtube.com/@StemFoxIO).
