import Foundation
// Models (MentalExercise, CombatDrill, MetalManipulation) are in Sources/Models.swift

// MARK: - Same Protocol, Same Trainers

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

// MARK: - Fix #1: `some Training`
//
// `some Training` means:
//
//   "I'm returning ONE specific type that conforms to Training.
//    I know exactly what it is. You, the caller, don't need to know —
//    you just need to know it's a Training."
//
// The compiler knows the exact concrete type (DangerRoomTraining).
// The caller only sees the protocol.
//
// This is called an OPAQUE RETURN TYPE.
// Opaque = "hidden from the outside, known on the inside."

func pickTrainer() -> some Training {
    return DangerRoomTraining()
}

let trainer = pickTrainer()
print("🎯 Got trainer: \(trainer.trainerName)")
print("   \(trainer.runSession())")

// Note: we use `runSession()` instead of accessing the Exercise directly.
// That's because `trainer` is typed as `some Training` — the caller only
// knows "it's SOME Training type." The specific Exercise type is hidden.
//
// `runSession()` returns a plain `String`, so it works across the opaque boundary.
// If we tried to access `.name` or `.targets` on the returned Exercise,
// the compiler would stop us:
//
//   let drill = trainer.createExercise()
//   print(drill.targets)  // ❌ 'some Training.Exercise' has no member 'targets'
//
// This is actually the point of opacity — the caller is SHIELDED from the details.

// MARK: - THIS Is Why SwiftUI Uses `some View`
//
// When you write:
//
//   var body: some View {
//       VStack {
//           Text("Hello")
//           Text("World")
//       }
//   }
//
// SwiftUI is saying: "Your body returns ONE specific View type.
// Under the hood, it's actually a VStack<TupleView<(Text, Text)>>.
// But you don't want to write that — and you don't need to.
// I know what it is. You just return it."
//
// It's one concrete type. Fast. Compile-time known. Zero runtime cost.

// MARK: - The Catch
//
// `some` means ONE specific type — always the same one.
// You CANNOT return different types from the same function:

/*
func pickTrainer(mood: String) -> some Training {
    if mood == "angry" {
        return DangerRoomTraining()   // ❌ Compiler: "No."
    } else {
        return CerebroTraining()       // ❌ Different type = error
    }
}
*/

// Why? Because `some` is a promise to the compiler:
// "Every call to this function returns the EXACT SAME concrete type."
//
// If you need to return different types based on runtime decisions,
// that's where `any` comes in. Next page.
