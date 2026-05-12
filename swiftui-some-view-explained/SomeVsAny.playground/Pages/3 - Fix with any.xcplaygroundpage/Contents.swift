import Foundation
// Models (MentalExercise, CombatDrill, MetalManipulation) are in Sources/Models.swift

// MARK: - Same Protocol, All Three Trainers

protocol Training {
    associatedtype Exercise
    var trainerName: String { get }
    func createExercise() -> Exercise
    func runSession() -> String
}

struct CerebroTraining: Training {
    let trainerName = "Professor X"
    func createExercise() -> MentalExercise {
        MentalExercise(name: "Telepathic Defense", focusLevel: 9)
    }
    func runSession() -> String {
        let ex = createExercise()
        return "🧠 \(ex.name) — focus level \(ex.focusLevel)/10"
    }
}

struct DangerRoomTraining: Training {
    let trainerName = "Wolverine"
    func createExercise() -> CombatDrill {
        CombatDrill(name: "Sentinel Squad", targets: 12)
    }
    func runSession() -> String {
        let ex = createExercise()
        return "⚔️ \(ex.name) — \(ex.targets) targets"
    }
}

struct MagnetoTraining: Training {
    let trainerName = "Magneto"
    func createExercise() -> MetalManipulation {
        MetalManipulation(name: "Lift the Golden Gate", weightKg: 887000)
    }
    func runSession() -> String {
        let ex = createExercise()
        return "🧲 \(ex.name) — \(Int(ex.weightKg)) kg"
    }
}

// MARK: - Fix #2: `any Training`
//
// `any Training` means:
//
//   "I'm returning SOMETHING that conforms to Training.
//    Could be any type. The specific type is decided at runtime.
//    It goes in a box that can hold any conforming value."
//
// The compiler DOESN'T know the exact type. It's wrapped in an
// EXISTENTIAL CONTAINER — a runtime box that can hold any Training.
//
// This is flexibility. It comes with a cost.

func pickTrainerByMood(_ mood: String) -> any Training {
    switch mood {
    case "focused":
        return CerebroTraining()
    case "angry":
        return DangerRoomTraining()
    default:
        return MagnetoTraining()
    }
}

// ✅ Now we CAN return different types based on runtime conditions
let trainer1 = pickTrainerByMood("focused")
let trainer2 = pickTrainerByMood("angry")
let trainer3 = pickTrainerByMood("powerful")

print("🧠 Trainer 1: \(trainer1.trainerName)")
print("⚔️  Trainer 2: \(trainer2.trainerName)")
print("🧲 Trainer 3: \(trainer3.trainerName)")

// ✅ We can even put them in an array together!
let roster: [any Training] = [trainer1, trainer2, trainer3]

print("\n📋 Full training roster:")
for t in roster {
    print("   • \(t.trainerName)")
    print("     \(t.runSession())")
}

// MARK: - The Cost of `any`
//
// Each `any Training` value is a runtime box.
// The compiler has to:
//   1. Store the type information alongside the value
//   2. Dynamic-dispatch method calls through that box
//   3. Allocate heap memory if the value is larger than the box
//
// `some` has NONE of these costs. The compiler sees right through it.
//
// You also LOSE something important: because `any Training` could be
// any Exercise type, calling createExercise() gives you back `any Exercise`.
// You can't use the result directly — you need to cast it.
//
// `any` buys you flexibility. You pay in performance AND ergonomics.
//
// Next page: side-by-side comparison to see the real difference.
