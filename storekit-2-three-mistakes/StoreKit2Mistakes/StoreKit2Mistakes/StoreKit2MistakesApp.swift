import SwiftUI

@main
struct StoreKit2MistakesApp: App {
    @State private var entitlements = EntitlementManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(entitlements)
                .task {
                    await entitlements.refreshEntitlements()
                }
        }
    }
}
