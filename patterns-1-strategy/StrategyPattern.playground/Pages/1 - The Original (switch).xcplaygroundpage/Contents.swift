import Foundation
import UIKit



/*:
 # 1 — The Original (switch)

 This mirrors `CalcFormat.swift` from the StemFox app.

 Look closely: there are **two switches on the same enum**.
 - `formatterStyle` (line below) already extracts a Strategy — by returning Apple's named-Strategy type `NumberFormatter.Style`. Past me half-saw it.
 - `applySettings` goes back to a regular switch on the same enum to do the rest of the configuration. Past me did not finish the job.

 The whole video is about finishing the job.
 */

import Foundation

enum FormatStyle: String {
    case decimal, scientific, engineering, fixed

    /// Past me already extracted Strategy here — by returning Apple's literal Strategy type.
    var formatterStyle: NumberFormatter.Style {
        switch self {
        case .decimal, .fixed:
            return .decimal
        case .scientific, .engineering:
            return .scientific
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

        // ❌ ...but here we go back to a switch on the SAME enum.
        // This is the smell. We already have a Strategy mechanism (above).
        // Why two patterns for the same data?
        switch style {
        case .engineering:
            f.maximumIntegerDigits = 3
        case .decimal:
            f.maximumIntegerDigits = 40
            f.minimumIntegerDigits = 1
        case .scientific:
            f.maximumIntegerDigits = 1
            f.minimumIntegerDigits = 1
        case .fixed:
            f.maximumIntegerDigits = 40
            f.minimumFractionDigits = maxFractionDigits
        }

        return f
    }
}

// MARK: - Try it

let avg = StatFormat(style: .decimal).formatter()
    .string(from: SampleStats.battingAverage) ?? ""
let revenue = StatFormat(style: .engineering).formatter()
    .string(from: SampleStats.teamRevenue) ?? ""
let attendance = StatFormat(style: .scientific, maxFractionDigits: 2).formatter()
    .string(from: SampleStats.leagueAttendance) ?? ""

print("Batting avg:  \(avg)")        // 0.328
print("Team revenue: \(revenue)")    // 11.5E9
print("Attendance:   \(attendance)") // 7.05E7

//: [Next: Closure on Enum →](@next)
