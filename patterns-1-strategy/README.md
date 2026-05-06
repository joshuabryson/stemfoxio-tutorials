# Patterns 1 — Strategy

Companion code for **Patterns That Make You A Better Swift Developer, Episode 1: Strategy Pattern.**

📺 Watch on YouTube: *(link added at publish time)*

## What's in this folder

A multi-page Swift Playground showing three forms of the same number-formatter logic, taken straight from the StemFox app's `CalcFormat.swift`:

1. **The Original (switch)** — what the code looked like before. A switch on the enum doing formatter configuration. Notice the existing `formatterStyle` property already returns Apple's literal named-Strategy type — past me half-saw the pattern.
2. **Closure on Enum** — the Swift-idiomatic Strategy form. Each case carries its configuration as a closure.
3. **Protocol Strategy** — the textbook GoF form. The switch is gone, polymorphism takes over, and you can extend without modifying the original code.

The sample data (baseball stats) lives in `Sources/BaseballStats.swift` so each page renders the same numbers and you can see how each style differs.

## Run it

Open `StrategyPattern.playground` in Xcode 15+. Use the page sidebar (View → Navigators → Show Project Navigator) to walk through pages 1 → 2 → 3. Each page is standalone and prints its outputs in the console.

## Built with

Swift 5.9, Xcode 15, iOS 17 target. Should work on any Xcode 14+ install.

## Series

This is Episode 1 of the **Patterns That Make You A Better Swift Developer** series. Episode 2 ships next.
