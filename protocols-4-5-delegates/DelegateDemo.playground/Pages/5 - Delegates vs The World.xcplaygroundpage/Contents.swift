import Foundation
// Models (Hero, Team) are in Sources/Models.swift

// MARK: - Final: Complete Delegate Pattern + Alternatives Comparison

// MARK: - The Delegate Protocol

protocol RosterDelegate: AnyObject {
    func rosterDidChange(_ team: Team)
}

// MARK: - The Sender

class RosterEditor {
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

// MARK: - Delegate Consumer

class BattleSimulator: RosterDelegate {
    func rosterDidChange(_ team: Team) {
        print("⚔️ Simulating battle with \(team.name)...")
        for hero in team.roster {
            print("   \(hero.codename) uses \(hero.power)!")
        }
        print("⚔️ \(team.name) wins!")
    }
}

// MARK: - Run the delegate pattern

print("=== DELEGATE PATTERN ===")
let editor = RosterEditor()
let simulator = BattleSimulator()
editor.delegate = simulator
editor.saveRoster()

// MARK: - Delegates vs The World

print("")
print("=== DELEGATES vs THE WORLD ===")
print("")

// MARK: 1. Closure Callbacks — one-off, simple

print("--- 1. Closure: One-off callbacks ---")

class RecruitmentBoard {
    func scout(completion: @escaping (Hero) -> Void) {
        // Simulate scouting a new recruit
        let recruit = Hero(
            name: "Remy LeBeau",
            power: "Kinetic Energy",
            codename: "Gambit"
        )
        completion(recruit)
    }
}

let board = RecruitmentBoard()
board.scout { hero in
    print("🔍 Scouted: \(hero.codename) — \(hero.power)")
}
// Use closures when: single callback, no ongoing relationship,
// one method is enough.

print("")

// MARK: 2. Delegate — ongoing relationship, multiple methods

print("--- 2. Delegate: Ongoing, multi-method contracts ---")
// Already demoed above. Use delegates when:
// - Multiple related callbacks (didUpdate, didFail, willBegin...)
// - Formal contract between objects
// - Ongoing relationship (not just a one-shot callback)
print("(See the RosterDelegate example above)")

print("")

// MARK: 3. NotificationCenter — broadcast to many

print("--- 3. NotificationCenter: 1-to-many broadcast ---")

extension Notification.Name {
    static let rosterUpdated = Notification.Name("rosterUpdated")
}

class RosterBroadcaster {
    func broadcastChange(team: Team) {
        NotificationCenter.default.post(
            name: .rosterUpdated,
            object: nil,
            userInfo: ["team": team.name, "count": team.roster.count]
        )
        print("📡 Roster broadcast sent")
    }
}

class MissionBriefing {
    init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onRosterUpdate),
            name: .rosterUpdated,
            object: nil
        )
    }

    @objc func onRosterUpdate(_ notification: Notification) {
        if let info = notification.userInfo,
           let name = info["team"] as? String,
           let count = info["count"] as? Int {
            print("📋 Mission briefing updated: \(name) — \(count) members")
        }
    }
}

class TrainingScheduler {
    init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onRosterUpdate),
            name: .rosterUpdated,
            object: nil
        )
    }

    @objc func onRosterUpdate(_ notification: Notification) {
        if let info = notification.userInfo,
           let name = info["team"] as? String {
            print("🏋️ Training schedule adjusted for \(name)")
        }
    }
}

let broadcaster = RosterBroadcaster()
let briefing = MissionBriefing()
let training = TrainingScheduler()

let newTeam = Team(
    name: "X-Force",
    roster: [
        Hero(name: "Wade Wilson", power: "Regeneration", codename: "Deadpool"),
        Hero(name: "Nathan Summers", power: "Telekinesis", codename: "Cable")
    ]
)
broadcaster.broadcastChange(team: newTeam)
// Both MissionBriefing AND TrainingScheduler received it!
// Use NotificationCenter when: unknown number of listeners,
// decoupled broadcasting, system-wide events.

print("")

// MARK: 4. Combine / async — reactive streams, SwiftUI world

print("--- 4. Combine / async: Reactive streams ---")
print("// In SwiftUI, you'd use @Observable instead of delegates.")
print("// Example:")
print("//")
print("//   @Observable")
print("//   class RosterStore {")
print("//       var team: Team?")
print("//   }")
print("//")
print("// SwiftUI views automatically react to changes.")
print("// No delegate needed — the framework handles it.")
print("")

// MARK: - The Decision Framework

print("=== WHEN TO USE WHAT ===")
print("""
┌─────────────────────┬──────────────────────────────┐
│ Pattern             │ Reach for it when...         │
├─────────────────────┼──────────────────────────────┤
│ Delegate            │ Ongoing 1-to-1, multi-method │
│ Closure             │ One-shot callback, simple    │
│ NotificationCenter  │ 1-to-many, unknown listeners │
│ Combine / async     │ Reactive streams, SwiftUI    │
└─────────────────────┴──────────────────────────────┘

Delegates aren't dead in SwiftUI —
they're just one tool in a bigger toolbox. 🧰
""")

