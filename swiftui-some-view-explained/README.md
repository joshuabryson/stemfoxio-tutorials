# SwiftUI — `some View` Explained

Code for the **`some View` Explained** video on [StemFoxIO](https://www.youtube.com/@StemFoxIO).

Every SwiftUI `View`'s `body` is declared as `some View`. This playground breaks down what that keyword actually does, why `any` exists as its counterpart, and when to reach for each.

## Pages

Open `SomeVsAny.playground` in Xcode. The pages are numbered in narrative order:

1. **Break It** — the compiler error that shows what `some` is solving.
2. **Fix with some** — using `some` to state "one specific type the caller doesn't need to name."
3. **Fix with any** — using `any` to allow a mixed collection of conforming types.
4. **Side-by-Side** — when to choose `some` vs `any` in real code.

## Requirements

Xcode 15 or newer.
