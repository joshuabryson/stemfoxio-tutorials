import Foundation
// Models (LightSpectrum, GroundWave, Particle) are in Sources/Models.swift

// MARK: - Associated Types: The Conforming Type Decides
//
// Scientific instruments all "take a reading" — but different instruments
// produce different KINDS of readings. A telescope gives you a light spectrum.
// A seismograph gives you a ground wave. A particle detector gives you a particle.
//
// This is the perfect case for an associated type: the protocol says
// "I produce a Reading of some kind" — and each conforming instrument
// decides WHAT that Reading type is.

// MARK: - The Protocol

protocol Instrument {
    associatedtype Reading            // ← the type placeholder
    var name: String { get }
    func takeReading() -> Reading     // ← returns the conformer's Reading type
}

// MARK: - Telescope Decides Reading = LightSpectrum

struct Telescope: Instrument {
    let name = "Hubble Space Telescope"

    func takeReading() -> LightSpectrum {  // ← TYPE decides, once
        LightSpectrum(
            wavelength: 656.3,  // Hydrogen-alpha emission line
            intensity: 0.87,
            source: "Andromeda Galaxy"
        )
    }
}

// MARK: - Seismograph Decides Reading = GroundWave

struct Seismograph: Instrument {
    let name = "USGS Station ANMO"

    func takeReading() -> GroundWave {  // ← TYPE decides, once
        GroundWave(
            magnitude: 6.2,
            depth: 15.3,
            epicenter: "San Andreas Fault"
        )
    }
}

// MARK: - Particle Detector Decides Reading = Particle

struct ParticleDetector: Instrument {
    let name = "ATLAS at CERN"

    func takeReading() -> Particle {  // ← TYPE decides, once
        Particle(
            mass: 1.67e-27,
            charge: 1,
            velocity: 299_792_458 * 0.99  // ~99% the speed of light
        )
    }
}

// MARK: - Each Instrument Produces Its Own Reading Type

let telescope = Telescope()
let spectrum = telescope.takeReading()
print("🔭 \(telescope.name)")
print("   Wavelength: \(spectrum.wavelength) nm from \(spectrum.source)")

let seismograph = Seismograph()
let wave = seismograph.takeReading()
print("\n🌋 \(seismograph.name)")
print("   Magnitude \(wave.magnitude) at \(wave.epicenter)")

let detector = ParticleDetector()
let particle = detector.takeReading()
print("\n⚛️  \(detector.name)")
print("   Particle mass: \(particle.mass) kg, charge \(particle.charge)")

// MARK: - The Pattern
//
// With `associatedtype`:
//   - The protocol defines the placeholder (Reading)
//   - The conforming type fills it in (LightSpectrum, GroundWave, Particle)
//   - The type decides ONCE, at conformance — not at each call site
//
// This is "type decides."
//
// Which is identical to generics, except for WHO makes the decision.
// Continue to page 4 for the reveal.
