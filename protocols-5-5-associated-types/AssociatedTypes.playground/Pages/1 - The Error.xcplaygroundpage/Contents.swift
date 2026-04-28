import Foundation
// Models (LightSpectrum, GroundWave, Particle) are in Sources/Models.swift

// MARK: - The Obvious Attempt
//
// Every Swift dev tries this eventually:
// a protocol with a generic parameter, just like a function or a struct.
//
// UNCOMMENT THE LINE BELOW TO SEE THE ERROR:

/*
protocol Cache<T> {
    func store(_ item: T)
    func retrieve() -> T?
}
*/





//
//protocol Cache<T> {
//    func store(_ item: T)
//    func retrieve() -> T?
//}





























// Error:
// "Protocols do not allow generic parameters;
//  use associated types instead"
//
// Wait, what? Why does this work for functions and structs,
// but not for protocols?
//
//   func process<T>(_ item: T) { ... }       ✅ works
//   struct Box<T> { let value: T }           ✅ works
//   protocol Cache<T> { ... }                ❌ no
//
// Swift isn't being arbitrary. It's telling you something
// fundamental about the difference between these features.

// MARK: - The Mental Model
//
// Here's the unlock:
//
// • Generics are for CALLERS.
//   When YOU call a generic function, YOU pick the type.
//
//   let numbers = [1, 2, 3]
//   process(numbers)  // caller chose T = Int
//
// • Associated types are for IMPLEMENTERS.
//   When a TYPE conforms to a protocol, THE TYPE picks its
//   associated type — once, at conformance.
//
//   struct DiskCache: Cache { associatedtype T = String }
//   // the conformer chose T = String
//
// Both are "this type is a variable."
// The only difference is WHO decides what it resolves to.
//
// That's the whole video. Everything else is proving it.

print("The error on this page is intentional — uncomment the protocol Cache<T> block to see it.")
print("Then continue to page 2 to see generics in action.")
