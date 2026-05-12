import Foundation
import StoreKit
import SwiftUI

/// MISTAKE #3 — BROKEN PATTERN
///
/// What tutorials and AI both emit for the "Restore Purchases" button:
/// `try await AppStore.sync()`. This is the wrong API for this button.
///
/// WHY IT'S BROKEN:
///   • `AppStore.sync()` does a heavyweight resync that prompts for the user's
///     password. Appropriate maybe once if a user explicitly says "I'm missing
///     a purchase that should be there." It's NOT what "Restore Purchases"
///     should do.
///   • In review, the password prompt + delay can fail or confuse the reviewer.
///     Combined with Mistake #2, this is a near-guaranteed 3.1.1 rejection.
///
/// See `RestoreFixed.swift` for the correct pattern.
enum Mistake3_Broken {
    struct BrokenRestoreButton: View {
        @State private var error: String?

        var body: some View {
            Button("Restore Purchases") {
                Task {
                    do {
                        // Wrong API. Prompts auth, slow, brittle.
                        try await AppStore.sync()
                    } catch {
                        self.error = error.localizedDescription
                    }
                }
            }
        }
    }
}
