import Foundation
// Models (MentalExercise, CombatDrill, MetalManipulation) are in Sources/Models.swift

// MARK: - The Training Protocol
// Different trainers produce different kinds of exercises.
// We use an `associatedtype` to let each conforming type
// specify what Exercise type they produce.

protocol Training {
    associatedtype Exercise
    var trainerName: String { get }
    func createExercise() -> Exercise
    func runSession() -> String  // Plain String — always accessible, no associated type
}

// MARK: - Three Concrete Trainers

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

// MARK: - Prove the types work individually

let dangerRoom = DangerRoomTraining()
let drill = dangerRoom.createExercise()
print("🎯 \(dangerRoom.trainerName) prepared: \(drill.name)")
print("   Targets: \(drill.targets)")

let cerebro = CerebroTraining()
let mental = cerebro.createExercise()
print("🧠 \(cerebro.trainerName) prepared: \(mental.name)")
print("   Focus Level: \(mental.focusLevel)/10")

// MARK: - Now Let's Try To Use Training As A Return Type
//
// Uncomment this function to see the infamous error:
//
// "Protocol 'Training' can only be used as a generic constraint
//  because it has Self or associated type requirements"
//
// This is the error that stops most Swift devs cold.

/*
func pickTrainer() -> Training {
    return DangerRoomTraining()
}
*/

// Why does this fail?
//
// Because `Training` has an associated type (`Exercise`), and the
// compiler doesn't know WHICH Exercise type to expect from the return value.
// Is it MentalExercise? CombatDrill? MetalManipulation?
//
// The type system needs a concrete answer. "Training" is a family of types,
// not one type. You can't hand it back like an Int.
//
// Think of it like ordering "a drink" at a bar. The bartender needs to know
// WHICH drink. Water? Coffee? Whiskey? "A drink" isn't enough information.
//
// Good news: Swift has TWO ways to fix this.
//   • `some Training` — "one specific type, hidden from you"
//   • `any Training` — "a box that can hold any conforming type"
//
// Next page: Fix #1 with `some`.
