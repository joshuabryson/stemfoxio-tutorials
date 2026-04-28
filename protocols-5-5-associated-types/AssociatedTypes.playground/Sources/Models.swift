import Foundation

// Shared Reading types for the Instrument protocol.
// Each scientific instrument produces a different kind of reading —
// that's what makes the protocol need an associated type.

public struct LightSpectrum {
    public let wavelength: Double  // nanometers
    public let intensity: Double   // 0.0 - 1.0
    public let source: String      // e.g., "Andromeda"

    public init(wavelength: Double, intensity: Double, source: String) {
        self.wavelength = wavelength
        self.intensity = intensity
        self.source = source
    }
}

public struct GroundWave {
    public let magnitude: Double   // Richter scale
    public let depth: Double       // km
    public let epicenter: String   // location name

    public init(magnitude: Double, depth: Double, epicenter: String) {
        self.magnitude = magnitude
        self.depth = depth
        self.epicenter = epicenter
    }
}

public struct Particle {
    public let mass: Double        // kg
    public let charge: Int         // elementary charge units
    public let velocity: Double    // m/s

    public init(mass: Double, charge: Int, velocity: Double) {
        self.mass = mass
        self.charge = charge
        self.velocity = velocity
    }
}
