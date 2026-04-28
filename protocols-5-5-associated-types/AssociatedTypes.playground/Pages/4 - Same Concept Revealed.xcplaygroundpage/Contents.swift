import Foundation
// Models (LightSpectrum, GroundWave, Particle) are in Sources/Models.swift

// MARK: - The Unifying Insight
//
// Put them side by side. What do you see?

// GENERICS: The CALLER decides T
struct Sensor<T> {
    let label: String
    let reading: T
}

// ASSOCIATED TYPES: The TYPE decides Reading
protocol Instrument {
    associatedtype Reading
    var name: String { get }
    func takeReading() -> Reading
}

// Both of these are "I have a type variable."
// The ONLY difference is who decides what the variable resolves to.
//
//   Sensor<T>                        Instrument
//   ---------------                  ------------------
//   <T> is a placeholder              associatedtype is a placeholder
//   filled in by caller               filled in by conformer
//   at each use                       once, at conformance
//
// Same tool. Different scope. Different decider.

// MARK: - Proof: These Two Approaches Do The Same Thing

// Approach 1 — Generic: caller picks the Reading type
let opticalSensor = Sensor(
    label: "Optical sensor",
    reading: LightSpectrum(wavelength: 486.1, intensity: 0.92, source: "Sun")
)

let seismicSensor = Sensor(
    label: "Seismic sensor",
    reading: GroundWave(magnitude: 4.3, depth: 10.0, epicenter: "Iceland")
)

print("🔬 Generic Sensor<T>:")
print("   \(opticalSensor.label) → \(opticalSensor.reading.source)")
print("   \(seismicSensor.label) → \(seismicSensor.reading.epicenter)")

// Approach 2 — Protocol with associated type: conformer picks Reading
struct RadioTelescope: Instrument {
    let name = "Arecibo (historical)"
    func takeReading() -> LightSpectrum {  // conformer picks LightSpectrum
        LightSpectrum(wavelength: 21.1e7, intensity: 0.65, source: "Hydrogen line")
    }
}

let arecibo = RadioTelescope()
print("\n🛰 Protocol Instrument (conformer picks Reading):")
print("   \(arecibo.name) → \(arecibo.takeReading().source)")

// Both accomplish the same thing: a typed "thing with a reading."
// Generics put the choice at the call site.
// Associated types put the choice at the conformance.

// MARK: - ⚠️ For the Type Theorists Watching
//
// Technically, generics and associated types differ in variance,
// existential support, and how they interact with `some`/`any`.
// You're right — they're not the SAME thing at the type-theory level.
//
// But for 99% of the Swift code you'll actually write, this mental
// model — "who decides the type?" — is the one that matters.
// It's the one that keeps you unstuck.
//
// (If you want the full type-theory rabbit hole, Swift's evolution
// proposals on `some` and `any` are a great read. Otherwise, carry on.)

// MARK: - The Whole Game
//
// Everyone teaches generics and associated types as separate features.
// They're not. They're the same tool — "this type is a variable" —
// applied at different scopes with different deciders.
//
// Once you see that, every protocol with an associated type
// suddenly makes sense.
//
// Continue to page 5 to see them combine.
