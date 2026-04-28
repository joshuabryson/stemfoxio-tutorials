import Foundation
// Models (LightSpectrum, GroundWave, Particle) are in Sources/Models.swift

// MARK: - Combining Them: The Power Move
//
// Once you see generics and associated types as the same concept,
// you can combine them. A generic function, constrained by a protocol,
// that references the protocol's associated type through the generic.
//
// This is where the Swift type system stops feeling like magic.

// MARK: - The Protocol

protocol Instrument {
    associatedtype Reading
    var name: String { get }
    func takeReading() -> Reading
}

// MARK: - Three Conformers (each picks its own Reading)

struct Telescope: Instrument {
    let name = "Hubble Space Telescope"
    func takeReading() -> LightSpectrum {
        LightSpectrum(wavelength: 656.3, intensity: 0.87, source: "Andromeda Galaxy")
    }
}

struct Seismograph: Instrument {
    let name = "USGS Station ANMO"
    func takeReading() -> GroundWave {
        GroundWave(magnitude: 6.2, depth: 15.3, epicenter: "San Andreas Fault")
    }
}

struct ParticleDetector: Instrument {
    let name = "ATLAS at CERN"
    func takeReading() -> Particle {
        Particle(mass: 1.67e-27, charge: 1, velocity: 299_792_458 * 0.99)
    }
}

// MARK: - The Power Move
//
// A generic function constrained on Instrument.
// The caller provides any type that conforms.
// Inside the function, we reference I.Reading — the conformer's Reading type.

func logObservation<I: Instrument>(_ instrument: I) -> I.Reading {
    let reading = instrument.takeReading()
    print("📡 \(instrument.name) produced a reading.")
    return reading
}

// Notice what's happening:
//   - `<I: Instrument>` is a generic — the CALLER picks which Instrument
//   - `I.Reading` is the associated type — the INSTRUMENT already picked it
//   - The function return type becomes whatever the conformer said it was
//
// Two deciders cooperating: the caller chooses the instrument,
// the instrument type chose its Reading. We use both.

// MARK: - Call It With Different Instruments

let spectrum = logObservation(Telescope())
print("   Wavelength: \(spectrum.wavelength) nm from \(spectrum.source)\n")

let wave = logObservation(Seismograph())
print("   Magnitude \(wave.magnitude) at \(wave.epicenter)\n")

let particle = logObservation(ParticleDetector())
print("   Particle charge: \(particle.charge), near light speed\n")

// Each call returns a different concrete type:
//   - Telescope call returns LightSpectrum
//   - Seismograph call returns GroundWave
//   - ParticleDetector call returns Particle
//
// The compiler resolves I.Reading to the conformer's Reading
// at each call site. No casts. No runtime checks. Just type safety.

// MARK: - The Practical Test
//
// Every time you need to parameterize code by type, ask ONE question:
//
//   "Does the caller decide, or does the type decide?"
//
//   Caller decides  → `<T>` (generic)
//   Type decides    → `associatedtype`
//   Both            → combine them, like logObservation above
//
// That's the whole game.

print("""

╔══════════════════════════════════════════════════════════╗
║               THE DECISION FRAMEWORK                     ║
╠══════════════════════════════════════════════════════════╣
║                                                          ║
║  One question — every time you're stuck:                 ║
║                                                          ║
║       "Does the CALLER decide, or does the TYPE?"        ║
║                                                          ║
║  ──────────────────────────────────────────────────────  ║
║                                                          ║
║   Caller decides  →  <T> generic                         ║
║   Type decides    →  associatedtype                      ║
║   Both            →  combine them                        ║
║                                                          ║
║  ──────────────────────────────────────────────────────  ║
║                                                          ║
║  Generics and associated types are the same tool.        ║
║  Different scope. Different decider.                     ║
║  Same concept.                                           ║
║                                                          ║
║  That's the whole game. 🎯                               ║
║                                                          ║
╚══════════════════════════════════════════════════════════╝
""")
