import Foundation
// Models (Hero, Team) are in Sources/Models.swift

// MARK: - The Spaghetti Problem
// RosterEditor directly reaches into BattleSimulator and StatsPanel.
// This is the tightly coupled code we'll fix with delegates.

class BattleSimulator {
    var team: Team?

    func runSimulation() {
        guard let team = team else {
            print("❌ No team loaded")
            return
        }
        print("⚔️ Simulating battle with \(team.name)...")
        for hero in team.roster {
            print("   \(hero.codename) uses \(hero.power)!")
        }
        print("⚔️ \(team.name) wins!")
    }
}

class StatsPanel {
    var team: Team?

    func displayStats() {
        guard let team = team else {
            print("❌ No team to display")
            return
        }
        print("📊 \(team.name) Stats:")
        print("   Members: \(team.roster.count)")
        for hero in team.roster {
            print("   • \(hero.codename) — \(hero.power)")
        }
    }
}

class RosterEditor {
    // 🚨 Direct references — tightly coupled!
    var battleSimulator = BattleSimulator()
    var statsPanel = StatsPanel()

    func saveRoster() {
        let xmen = Team(
            name: "X-Men",
            roster: [
                Hero(name: "Logan", power: "Healing Factor", codename: "Wolverine"),
                Hero(name: "Ororo Munroe", power: "Weather Manipulation", codename: "Storm"),
                Hero(name: "Scott Summers", power: "Optic Blast", codename: "Cyclops")
            ]
        )

        // Reaching directly into other objects...
        battleSimulator.team = xmen
        statsPanel.team = xmen

        print("✅ Roster saved!")
        battleSimulator.runSimulation()
        statsPanel.displayStats()
    }
}

// MARK: - Run It

let editor = RosterEditor()
editor.saveRoster()

// ✅ This "works" — but what happens when we need to add more consumers?
// We'll find out live...
