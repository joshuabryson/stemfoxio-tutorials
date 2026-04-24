import Foundation
// Models (Hero, Team) are in Sources/Models.swift

// MARK: - Chapter 3 End: Refactored with Delegate Pattern
// RosterEditor no longer knows about its consumers.
// It just calls the delegate. Clean, decoupled, scalable.

// MARK: - Step 1: The Protocol (the "job contract")

protocol RosterDelegate: AnyObject {
    func rosterDidChange(_ team: Team)
}

// MARK: - Step 2: The Sender (has a weak delegate)

class RosterEditor {
    // ✅ One weak reference instead of N direct references
    weak var delegate: RosterDelegate?

    func saveRoster() {
        let xmen = Team(
            name: "X-Men",
            roster: [
                Hero(name: "Logan", power: "Healing Factor", codename: "Wolverine"),
                Hero(name: "Ororo Munroe", power: "Weather Manipulation", codename: "Storm"),
                Hero(name: "Scott Summers", power: "Optic Blast", codename: "Cyclops")
            ]
        )

        print("✅ Roster saved!")
        delegate?.rosterDidChange(xmen)
    }
}

// MARK: - Step 3: The Receivers (conform to the protocol)

class BattleSimulator: RosterDelegate {
    func rosterDidChange(_ team: Team) {
        print("⚔️ Simulating battle with \(team.name)...")
        for hero in team.roster {
            print("   \(hero.codename) uses \(hero.power)!")
        }
        print("⚔️ \(team.name) wins!")
    }
}

class StatsPanel: RosterDelegate {
    func rosterDidChange(_ team: Team) {
        print("📊 \(team.name) Stats:")
        print("   Members: \(team.roster.count)")
        for hero in team.roster {
            print("   • \(hero.codename) — \(hero.power)")
        }
    }
}

class LineupCard: RosterDelegate {
    func rosterDidChange(_ team: Team) {
        print("🃏 LINEUP CARD: \(team.name)")
        for (i, hero) in team.roster.enumerated() {
            print("   \(i + 1). \(hero.codename)")
        }
    }
}

// MARK: - Run It — One Consumer

print("--- With BattleSimulator as delegate ---")
let editor = RosterEditor()
let simulator = BattleSimulator()
editor.delegate = simulator
editor.saveRoster()

print("")

// MARK: - Swap the Consumer — Zero Changes to RosterEditor

print("--- With StatsPanel as delegate ---")
let stats = StatsPanel()
editor.delegate = stats
editor.saveRoster()

print("")

print("--- With LineupCard as delegate ---")
let card = LineupCard()
editor.delegate = card
editor.saveRoster()

class RosterUpdater: RosterDelegate {
    var delegates: [RosterDelegate]

    init(delegates: [RosterDelegate]) {
        self.delegates = delegates
    }

    func rosterDidChange(_ team: Team) {
        for delegate in delegates {
            delegate.rosterDidChange(team)
        }
    }
}
print("")
print("")

print("--- With RosterUpdater as delegate ---")

let updater = RosterUpdater(delegates: [simulator, stats, card])
editor.delegate = updater
editor.saveRoster()


// ✅ RosterEditor didn't change AT ALL.
// We just swapped who's listening.
// That's the power of delegation — the sender doesn't care who the delegate is.

// 💡 Note: Only ONE delegate can listen at a time.
// That's by design — delegates are 1-to-1 relationships.
// Need 1-to-many? That's what NotificationCenter is for.
// We'll cover that in Page 5: "Delegates vs The World."
