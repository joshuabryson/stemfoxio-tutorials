import Foundation
// Models (Hero, Team) are in Sources/Models.swift

// MARK: - Chapter 4 End: Bulletproof Delegates
// Added: weak explained, AnyObject explained, retain cycle demo,
// optional chaining behavior shown.

// MARK: - The Protocol

protocol RosterDelegate: AnyObject {
    // AnyObject constrains this to class types only.
    // Why? Because `weak` only works with reference types (classes).
    // Without AnyObject, a struct could conform — and you can't
    // make a weak reference to a struct.
    func rosterDidChange(_ team: Team)
}

// MARK: - The Sender

class RosterEditor {
    // `weak` prevents a retain cycle.
    //
    // Without `weak`:
    //   RosterEditor -> delegate (strong)
    //   Delegate -> rosterEditor (strong, if it holds a ref back)
    //   = Neither can be deallocated. Memory leak. 💀
    //
    // With `weak`:
    //   RosterEditor -> delegate (weak — doesn't keep it alive)
    //   Delegate -> rosterEditor (strong)
    //   = When the delegate goes away, this reference becomes nil. Clean. ✅
    weak var delegate: RosterDelegate?

    func saveRoster() {
        let brotherhood = Team(
            name: "Brotherhood of Mutants",
            roster: [
                Hero(name: "Erik Lehnsherr", power: "Magnetism", codename: "Magneto"),
                Hero(name: "Raven Darkhölme", power: "Shapeshifting", codename: "Mystique"),
                Hero(name: "Victor Creed", power: "Feral Senses", codename: "Sabretooth")
            ]
        )

        print("✅ Roster saved!")

        // Optional chaining: if delegate is nil, this just... doesn't run.
        // No crash, no error. Silent no-op. That's fine —
        // it means nobody's listening right now.
        delegate?.rosterDidChange(brotherhood)
    }
}

// MARK: - The Receiver

class BattleSimulator: RosterDelegate {
    func rosterDidChange(_ team: Team) {
        print("⚔️ Simulating battle with \(team.name)...")
        for hero in team.roster {
            print("   \(hero.codename) uses \(hero.power)!")
        }
        print("⚔️ \(team.name) wins!")
    }

    deinit {
        print("🗑️ BattleSimulator deallocated — no retain cycle!")
    }
}

// MARK: - Prove It: No Retain Cycle

print("--- Retain cycle demo ---")

let editor = RosterEditor()

// Scope the simulator so it can be deallocated
do {
    let simulator = BattleSimulator()
    editor.delegate = simulator
    editor.saveRoster()
    print("Simulator is about to go out of scope...")
}
// If `weak` is working, BattleSimulator's deinit fires here ✅
// If we forgot `weak`, it would NEVER fire — memory leak 💀

print("")
print("--- Calling saveRoster with no delegate ---")
editor.saveRoster()
// delegate is nil now — optional chaining means nothing crashes.
// The roster editor doesn't care that nobody's listening.

// MARK: - 🔥 JOSHUA'S WAR STORY GOES HERE 🔥
// Talk about the time you forgot `weak` in production.
// The retain cycle, the memory climbing, how you found it.
// Let the story breathe — this is the moment viewers remember.
