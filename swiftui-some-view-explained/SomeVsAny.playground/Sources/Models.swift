import Foundation

// Shared Exercise types used by the Training protocol across all pages.
// Each trainer produces a different Exercise type — that's what makes
// `Training` need an associated type.

public struct MentalExercise {
    public let name: String
    public let focusLevel: Int  // 1-10

    public init(name: String, focusLevel: Int) {
        self.name = name
        self.focusLevel = focusLevel
    }
}

public struct CombatDrill {
    public let name: String
    public let targets: Int

    public init(name: String, targets: Int) {
        self.name = name
        self.targets = targets
    }
}

public struct MetalManipulation {
    public let name: String
    public let weightKg: Double

    public init(name: String, weightKg: Double) {
        self.name = name
        self.weightKg = weightKg
    }
}
