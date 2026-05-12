import Foundation
// Models (MentalExercise, CombatDrill, MetalManipulation) are in Sources/Models.swift

// MARK: - Protocol + Trainers

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

// MARK: - Side 1: `some Training`
// Always returns ONE specific concrete type.

print("=== `some Training` ===")

func assignDailyTrainer() -> some Training {
    return DangerRoomTraining()
}

let today = assignDailyTrainer()
let tomorrow = assignDailyTrainer()
print("Today: \(today.trainerName)")
print("Tomorrow: \(tomorrow.trainerName)")

// ✅ We can call runSession() — it returns a String, which works across
// the opaque boundary.
print("Session: \(today.runSession())")

// ⚠️ But notice: we CAN'T access Exercise fields directly from here.
//   let drill = today.createExercise()
//   print(drill.targets)  // ❌ 'some Training.Exercise' has no member 'targets'
//
// That's `some` doing its job — hiding the specific type from the caller.
// Inside the concrete DangerRoomTraining struct, we CAN access .targets,
// which is why runSession() can format the string for us.

// ❌ Try to build a mixed array with `some Training` — FAILS:
//
// let mixedRoster: [some Training] = [
//     DangerRoomTraining(),
//     CerebroTraining()      // ← different concrete type, compiler rejects
// ]
//
// Error: "Cannot convert value of type 'CerebroTraining' to
//         expected element type 'DangerRoomTraining'"
//
// `some Training` means ONE specific type. You can't mix them.

// MARK: - Side 2: `any Training`
// A runtime box that can hold any conforming type.

print("\n=== `any Training` ===")

// ✅ Mixed roster — different concrete types in the same array
let xmen: [any Training] = [
    CerebroTraining(),
    DangerRoomTraining(),
    MagnetoTraining()
]

print("Full X-Men training roster:")
for trainer in xmen {
    print("   • \(trainer.trainerName)")
    print("     \(trainer.runSession())")
}

// ✅ runSession() works fine — it returns a String.
//
// ⚠️ But try calling createExercise() across the `any` boundary:
//
// for trainer in xmen {
//     let exercise = trainer.createExercise()
//     print(exercise.targets)  // ❌ compiler error
// }
//
// Same problem as `some`: the Exercise type is hidden.
// With `any`, you'd have to cast each result at runtime to use the fields.
// That's the existential tax — you lose compile-time knowledge.

// MARK: - The Decision Framework (MY TAKE)

print("""

╔══════════════════════════════════════════════════════════╗
║            DECISION FRAMEWORK — MY TAKE                  ║
╠══════════════════════════════════════════════════════════╣
║                                                          ║
║  Start with `some`. ALWAYS start with `some`.            ║
║                                                          ║
║  ✓ You know the exact type                               ║
║  ✓ The compiler optimizes everything                     ║
║  ✓ It's what SwiftUI gives you for free                  ║
║  ✓ You get direct access to return values                ║
║                                                          ║
║  Reach for `any` ONLY when you hit a real wall:          ║
║                                                          ║
║  ✓ You need a collection of DIFFERENT conforming types   ║
║  ✓ The type is genuinely unknown until runtime           ║
║  ✓ You need to store it in a property of type `any X`    ║
║                                                          ║
║  Most tutorials show `any` first because it              ║
║  "feels more flexible." DON'T FALL FOR IT.               ║
║                                                          ║
║  Flexibility you don't need is just cost                 ║
║  you don't see.                                          ║
║                                                          ║
║  Ask yourself: "What's the minimum power I need?"        ║
║    → Can I describe it with one type?   Use `some`.      ║
║    → Do I actually need heterogeneity?  Use `any`.       ║
║                                                          ║
║  That's it. That's the whole game.                       ║
║                                                          ║
╚══════════════════════════════════════════════════════════╝
""")
