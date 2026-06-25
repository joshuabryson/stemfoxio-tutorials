# Neovim for iOS Development — Set Up by Claude

Companion files for the StemFoxIO video **"I Ditched Xcode for Neovim — and Let Claude Set It All Up."**

> 📺 Video: _(link added when published)_

This isn't a copy-paste config dump. The point of the video is that you let **Claude** build your Neovim config against your own needs, then learn what it built — so the setup grows with your understanding instead of being a black box you're afraid to touch.

## What's in here

```
neovim-ios-setup/
├── README.md        ← (this file)
├── PROMPTS.md       ← THE deliverable: the exact Claude prompt sequence, in order
└── cheatsheet.html  ← keybind cheat sheet — open it in a browser beside your editor
```

## How to use

1. Open `PROMPTS.md`.
2. From the directory where you want your Neovim config, paste the prompts into Claude Code **in order** — install → configure for Swift + iOS → theme → lint/format → test setup → fix fonts → cheat sheet.
3. After each step, ask Claude *"what did you just add and why?"* Own the config.
4. Keep `cheatsheet.html` open while the bindings become muscle memory.

## The stack it lands on

A standard, current iOS-in-Neovim toolchain:

- **SourceKit-LSP** (via `nvim-lspconfig`) — completion + diagnostics
- **`wojciech-kulik/xcodebuild.nvim`** — build / run / test / scheme / device, from the editor
- **`nvim-telescope/telescope.nvim`** — fuzzy file search
- **`nvim-treesitter`** — syntax / parsing
- **swiftformat + swiftlint** — formatting and linting
- **JetBrains Mono Nerd Font** — so the status-line glyphs render

## Requirements

- macOS with Xcode + command-line tools installed (you still need the Apple toolchain — Neovim drives it, it doesn't replace it)
- Neovim 0.10+
- Claude Code

---

_StemFoxIO teaches iOS/Swift development. Understand the code you ship — don't just paste it._
