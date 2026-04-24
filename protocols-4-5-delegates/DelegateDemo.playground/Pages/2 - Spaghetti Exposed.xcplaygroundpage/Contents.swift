import Foundation
// Models (Hero, Team) are in Sources/Models.swift

// MARK: - Chapter 1 End: The Spaghetti Problem — Exposed
// We've added a third consumer (LineupCard) and now the
// coupling is painfully visible. RosterEditor owns everything.

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

class LineupCard {
    var team: Team?

    func printCard() {
        guard let team = team else {
            print("❌ No lineup")
            return
        }
        print("🃏 LINEUP CARD: \(team.name)")
        for (i, hero) in team.roster.enumerated() {
            print("   \(i + 1). \(hero.codename)")
        }
    }
}

class RosterEditor {
    // 🚨 Every new consumer = another direct reference
    var battleSimulator = BattleSimulator()
    var statsPanel = StatsPanel()
    var lineupCard = LineupCard()  // And growing...

    func saveRoster() {
        let xmen = Team(
            name: "X-Men",
            roster: [
                Hero(name: "Logan", power: "Healing Factor", codename: "Wolverine"),
                Hero(name: "Ororo Munroe", power: "Weather Manipulation", codename: "Storm"),
                Hero(name: "Scott Summers", power: "Optic Blast", codename: "Cyclops")
            ]
        )

        battleSimulator.team = xmen
        statsPanel.team = xmen
        lineupCard.team = xmen

        print("✅ Roster saved!")
        battleSimulator.runSimulation()
        statsPanel.displayStats()
        lineupCard.printCard()
    }
}

// MARK: - The Problem Is Clear

let editor = RosterEditor()
editor.saveRoster()

// RosterEditor now knows about BattleSimulator, StatsPanel, AND LineupCard.
// What about a TrainingScheduler? A MissionBriefing? A RecruitmentBoard?
// Each one means MORE direct references in RosterEditor.
//
// This is the spaghetti. Let's clean it up with the delegate pattern.
