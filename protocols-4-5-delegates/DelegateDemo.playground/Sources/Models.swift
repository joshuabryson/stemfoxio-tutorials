import Foundation

public struct Hero {
    public let name: String
    public let power: String
    public let codename: String

    public init(name: String, power: String, codename: String) {
        self.name = name
        self.power = power
        self.codename = codename
    }
}

public struct Team {
    public let name: String
    public let roster: [Hero]

    public init(name: String, roster: [Hero]) {
        self.name = name
        self.roster = roster
    }
}
