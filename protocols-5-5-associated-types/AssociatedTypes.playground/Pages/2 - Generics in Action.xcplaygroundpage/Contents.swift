import Foundation

// MARK: - Generics: The Caller Decides
//
// When you write a generic function, you define a placeholder type `T`.
// The CALLER fills in `T` at each call site.
//
// This is the same concept as associated types — but applied at the
// function level instead of the protocol level.

// MARK: - A Generic Function

func largest<T: Comparable>(_ items: [T]) -> T? {
    guard !items.isEmpty else { return nil }
    var result = items[0]
    for item in items.dropFirst() where item > result {
        result = item
    }
    return result
}

// MARK: - Call Site 1 — Caller Decides T = Int

let earthquakeMagnitudes = [6.2, 4.8, 7.1, 5.5, 3.9]
if let biggest = largest(earthquakeMagnitudes) {
    print("🌋 Largest earthquake magnitude: \(biggest)")
}
// Here, the CALLER passed a [Double] so T = Double.

// MARK: - Call Site 2 — Caller Decides T = String

let observatories = ["Hubble", "Keck", "Arecibo", "VLT"]
if let lastAlphabetical = largest(observatories) {
    print("🔭 Last alphabetical observatory: \(lastAlphabetical)")
}
// Same function. Same <T>. Different type.
// The CALLER decides — every call site makes its own choice.

// MARK: - Call Site 3 — Generic Types Too

struct Reading<T: Numeric> {
    let label: String
    let value: T
}

let temperature = Reading(label: "Core temperature", value: 1.5e7)
let waveCount = Reading(label: "Wave count", value: 42)

print("🌡  \(temperature.label): \(temperature.value) K")
print("📊 \(waveCount.label): \(waveCount.value)")
// `struct Reading<T>` works the same way: the CALLER
// decides T when they create an instance.

// MARK: - The Pattern
//
// With `<T>`:
//   - You define the placeholder
//   - The caller fills it in
//   - Each call site can pick a different type
//
// This is "caller decides."
//
// Now flip it around. What if the TYPE decides, not the caller?
// That's what `associatedtype` is for.
//
// Continue to page 3.
