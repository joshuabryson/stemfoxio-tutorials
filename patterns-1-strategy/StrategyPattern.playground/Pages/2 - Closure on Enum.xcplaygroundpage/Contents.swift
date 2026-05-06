/*:
 # 2 — Strategy via Closure on Enum

 The Swift-idiomatic form. Each case carries its strategy *as data* — a closure attached to the case via a computed property.

 The outer switch in `formatter()` is gone. The configuration code now lives next to the case it belongs to — read top-to-bottom, you see exactly what each format does.

 - **Pro:** ergonomic, no protocol overhead, all logic in one file.
 - **Con:** strategies can only be added by editing the enum — closed to outside extension. If you need to plug in a strategy from a different module or test in isolation, you'll want the protocol form on page 3.
 */

import Foundation

enum FormatStyle: String {
    case decimal, scientific, engineering, fixed

    var formatterStyle: NumberFormatter.Style {
        switch self {
        case .decimal, .fixed:          return .decimal
        case .scientific, .engineering: return .scientific
        }
    }

    /// The Strategy lives on the enum itself — each case carries its configuration.
    var configure: (NumberFormatter, Int) -> Void {
        switch self {
        case .engineering:
            return { f, _ in f.maximumIntegerDigits = 3 }
        case .decimal:
            return { f, _ in
                f.maximumIntegerDigits = 40
                f.minimumIntegerDigits = 1
            }
        case .scientific:
            return { f, _ in
                f.maximumIntegerDigits = 1
                f.minimumIntegerDigits = 1
            }
        case .fixed:
            return { f, max in
                f.maximumIntegerDigits = 40
                f.minimumFractionDigits = max
            }
        }
    }
}

struct StatFormat {
    var style: FormatStyle = .decimal
    var maxFractionDigits: Int = 3

    func formatter() -> NumberFormatter {
        let f = NumberFormatter()
        f.numberStyle = style.formatterStyle
        f.maximumFractionDigits = maxFractionDigits
        f.minimumFractionDigits = 0

        // ✅ One line. The Strategy decides how to configure.
        style.configure(f, maxFractionDigits)

        return f
    }
}

// MARK: - Try it (same data, same outputs as page 1)

let avg = StatFormat(style: .decimal).formatter()
    .string(from: SampleStats.battingAverage) ?? ""
let revenue = StatFormat(style: .engineering).formatter()
    .string(from: SampleStats.teamRevenue) ?? ""

print("Batting avg:  \(avg)")
print("Team revenue: \(revenue)")

//: [← Previous](@previous) | [Next: Protocol Strategy →](@next)
