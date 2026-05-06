/*:
 # 3 — Strategy via Protocol (the GoF form)

 The textbook Strategy Pattern. Each format is its own type conforming to a protocol. The switch is **gone** — replaced with polymorphism.

 ## What this unlocks
 - **Test each strategy in isolation** — every conformer is its own value type.
 - **Compose at runtime** — pick a strategy at the moment of use, swap freely.
 - **Extend from outside the module** — add a `PercentStrategy` without touching the original code (see bottom of page).

 ## When to choose this over closure-on-enum
 - When strategies need their own state.
 - When strategies need to be swapped from outside the type.
 - When you want each strategy testable in isolation.

 If none of those apply, the closure-on-enum form on page 2 is plenty.
 */

import Foundation

protocol NumberStyleStrategy {
    var appleStyle: NumberFormatter.Style { get }
    func configure(_ formatter: NumberFormatter, maxFractionDigits: Int)
}

struct DecimalStrategy: NumberStyleStrategy {
    let appleStyle: NumberFormatter.Style = .decimal
    func configure(_ f: NumberFormatter, maxFractionDigits: Int) {
        f.maximumIntegerDigits = 40
        f.minimumIntegerDigits = 1
    }
}

struct ScientificStrategy: NumberStyleStrategy {
    let appleStyle: NumberFormatter.Style = .scientific
    func configure(_ f: NumberFormatter, maxFractionDigits: Int) {
        f.maximumIntegerDigits = 1
        f.minimumIntegerDigits = 1
    }
}

struct EngineeringStrategy: NumberStyleStrategy {
    let appleStyle: NumberFormatter.Style = .scientific
    func configure(_ f: NumberFormatter, maxFractionDigits: Int) {
        f.maximumIntegerDigits = 3
    }
}

struct FixedStrategy: NumberStyleStrategy {
    let appleStyle: NumberFormatter.Style = .decimal
    func configure(_ f: NumberFormatter, maxFractionDigits: Int) {
        f.maximumIntegerDigits = 40
        f.minimumFractionDigits = maxFractionDigits
    }
}

struct StatFormat {
    var strategy: NumberStyleStrategy = DecimalStrategy()
    var maxFractionDigits: Int = 3

    func formatter() -> NumberFormatter {
        let f = NumberFormatter()
        f.numberStyle = strategy.appleStyle
        f.maximumFractionDigits = maxFractionDigits
        f.minimumFractionDigits = 0

        strategy.configure(f, maxFractionDigits: maxFractionDigits)

        return f
    }
}

// MARK: - Try it

let avg = StatFormat(strategy: DecimalStrategy()).formatter()
    .string(from: SampleStats.battingAverage) ?? ""
let revenue = StatFormat(strategy: EngineeringStrategy()).formatter()
    .string(from: SampleStats.teamRevenue) ?? ""

print("Batting avg:  \(avg)")
print("Team revenue: \(revenue)")

/*:
 ## The payoff: extend without modifying

 Below is a brand-new strategy that wasn't in the original system. We add it without touching `StatFormat`, `NumberStyleStrategy`, or any of the four strategies above. **That's the win.** This is the moment Strategy earns its keep over the closure-on-enum form — and over the original switch.
 */

struct PercentStrategy: NumberStyleStrategy {
    let appleStyle: NumberFormatter.Style = .percent

    func configure(_ formatter: NumberFormatter, maxFractionDigits: Int) {
        formatter.minimumFractionDigits = 1
    }
}

let obp = StatFormat(strategy: PercentStrategy()).formatter()
    .string(from: SampleStats.onBasePercentage) ?? ""

print("On base %: ", obp)

//: [← Previous](@previous)
