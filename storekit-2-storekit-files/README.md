# StoreKit 2: Master `.storekit` Files (Full Tour)

Code companion for **Episode 2 of *StoreKit 2: Ship It Right*** on the [StemFoxIO YouTube channel](https://www.youtube.com/@StemFoxIO).

In this episode we take Xcode's `.storekit` configuration file on a full tour — happy path, state editing, edge cases, and dev-loop speed-ups — without ever opening App Store Connect.

## Watch the video

📺 _Master `.storekit` Files in Xcode_ — link filled in when published.

## What's in this project

A minimal SwiftUI app extending the **Ep 1** scaffold (same paywall + entitlement listener) with a new `.storekit` configuration file, an additional Pro Annual subscription, and a small status banner that surfaces what the `Transaction.updates` listener is doing in real time.

```
StoreKit2StoreKitFiles/
├── StoreKit2StoreKitFilesApp.swift     ← @main with EntitlementManager
├── ContentView.swift              ← home screen + status banner (Ep 2 Ch 2)
├── PaywallView.swift              ← IAP UI with Restore Purchases
├── EntitlementManager.swift       ← Transaction.updates listener + describe(_:)
├── Models/
│   ├── Hero.swift                 ← sample data for the team list
│   └── ProductIDs.swift           ← Pro Monthly + Pro Annual + Lifetime Access
└── Products.storekit              ← StoreKit configuration (3 products, 1 subscription group)
```

## Products in `Products.storekit`

| Display name | Type | Product ID | Price |
|---|---|---|---|
| Pro Monthly | Auto-renewing subscription | `com.stemfoxio.StoreKit2Mistakes.proMonthly` | $4.99 |
| Pro Annual | Auto-renewing subscription *(same group as Monthly)* | `com.stemfoxio.StoreKit2Mistakes.proAnnual` | $39.99 |
| Lifetime Access | Non-consumable | `com.stemfoxio.StoreKit2Mistakes.unlockPro` | $99.99 |

## Getting it running

1. Open `StoreKit2StoreKitFiles.xcodeproj` (inside `StoreKit2StoreKitFiles/`).
2. **Select the StoreKit configuration**: Edit Scheme → Run → Options → StoreKit Configuration → choose `Products.storekit`.
3. Build and run on the simulator.
4. The paywall is reachable from the crown icon in the top-right of the home screen.

## Trying the things the video covers

- **Happy path**: tap the crown → Subscribe → see the status banner appear.
- **Manage Transactions**: Debug → StoreKit → Manage Transactions → refund / expire / renew live.
- **Edge cases**: same panel — toggle Ask to Buy in the scheme, force network failure on a transaction, force a refund.
- **Time Rate**: Edit Scheme → Run → Options → StoreKit → Default StoreKit Configuration → Time Rate → set to *Real time × 1 day = 5 seconds* (or similar). Subscriptions now renew every few seconds.

## Watching the listener react

The status banner at the top of the home screen shows whatever `EntitlementManager` last received on `Transaction.updates` — refund, expiration, upgrade, or fresh purchase. This is the visible proof that your listener is doing its job under each forced edge case.

## Series

- **Ep 1**: [3 StoreKit 2 Mistakes Apple Rejects](https://youtu.be/EPJAW4AZamY) — `storekit-2-three-mistakes/`
- **Ep 2**: *(this episode)* — `.storekit` file mastery
- **Ep 3**: *(coming)* — Automated UI testing for StoreKit 2
- **Ep 4**: *(coming)* — Server-side receipt validation
- **Ep 5 (bonus)**: *(coming)* — Subscription offers and intro pricing
