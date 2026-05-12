import Foundation

struct Hero: Identifiable, Hashable {
    let id: String
    let name: String
    let role: Role
    let powerLevel: Int

    enum Role: String, CaseIterable, Hashable {
        case bruiser = "Bruiser"
        case telepath = "Telepath"
        case elemental = "Elemental"
        case stealth = "Stealth"
        case leader = "Leader"
    }
}

extension Hero {
    static let roster: [Hero] = [
        Hero(id: "wolverine", name: "Wolverine", role: .bruiser, powerLevel: 88),
        Hero(id: "storm", name: "Storm", role: .elemental, powerLevel: 92),
        Hero(id: "magneto", name: "Magneto", role: .leader, powerLevel: 96),
        Hero(id: "jean-grey", name: "Jean Grey", role: .telepath, powerLevel: 95),
        Hero(id: "cyclops", name: "Cyclops", role: .leader, powerLevel: 84),
        Hero(id: "nightcrawler", name: "Nightcrawler", role: .stealth, powerLevel: 78),
        Hero(id: "rogue", name: "Rogue", role: .bruiser, powerLevel: 86),
        Hero(id: "gambit", name: "Gambit", role: .stealth, powerLevel: 75),
        Hero(id: "beast", name: "Beast", role: .bruiser, powerLevel: 80),
        Hero(id: "professor-x", name: "Professor X", role: .telepath, powerLevel: 99),
    ]
}
