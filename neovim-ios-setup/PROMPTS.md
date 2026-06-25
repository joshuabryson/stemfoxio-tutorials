# The Claude Prompts — Neovim for iOS Development

This is the deliverable. The whole point of the video is that you don't memorize a Lua config — you let Claude build it, then learn what it built. Below is the exact prompt sequence from the video, in order, with the context that makes each one work. Paste them into Claude Code from inside the directory where you want your Neovim config to live.

> **Read what it ships.** Claude writes the config; you own it. After each step, ask Claude *"what did you just add and why?"* before moving on. Understanding the tools is the difference between a setup you can fix and a setup you're afraid to touch.

---

## 1. Install Neovim

```
Hey Claude, could you install Neovim for me? Put auto-accept mode on so I
don't have to confirm every step.
```

Claude handles the install (Homebrew on macOS) and verifies `nvim` launches. If you'd rather do it by hand, grab the macOS/ARM64 build from https://neovim.io.

## 2. Configure it for Swift *and iOS* development

```
I've got Neovim running. Let's get this ready for Swift and iOS development —
and those are two different things. For iOS we also need the Xcode build
tools, and I want to drive them right from Neovim. At minimum I want:
  - Swift syntax highlighting
  - a build system (build / run / test without leaving the editor)
  - fuzzy file search and the ability to open any file in the project
Set up the config and explain what each plugin does.
```

This is the load-bearing prompt. The explicit "Swift **and** iOS" distinction is what gets you the Xcode toolchain integration (SourceKit-LSP + an Xcode build/test bridge) instead of a plain Swift-syntax setup. Asking Claude to *explain each plugin* turns the config into a lesson, not a black box.

What the video's setup lands on (a standard, current iOS-in-Neovim stack):

| Need | Tool |
| --- | --- |
| Swift LSP (completion, diagnostics) | **SourceKit-LSP** via `nvim-lspconfig` |
| Build / run / test / scheme / device | **`wojciech-kulik/xcodebuild.nvim`** |
| Fuzzy file search | **`nvim-telescope/telescope.nvim`** |
| Syntax / parsing | **`nvim-treesitter`** |
| Format + lint | **swiftformat** + **swiftlint** (via a formatter plugin) |
| Config language | **Lua** (`init.lua` + a `lua/` config tree) |

## 3. Make it yours — port your Xcode theme

```
Could you use my Dark Yella Xcode theme for the syntax highlighting instead?
Go find it in my Xcode user data and convert it.
```

Claude searches your Xcode user data, converts the color theme, and wires it in. This is the moment the editor stops being someone else's config and starts being yours. Swap "Dark Yella" for whatever `.xccolortheme` you use.

## 4. Clean up a file fast (lint + format)

```
How can I clean up the lint and formatting errors on this file real quick?
```

Because Claude already has the project context, it tells you the keybinding it wired up (in the video: `<leader>cf`) and what it does. Run it, watch the trailing-whitespace and lint noise disappear.

## 5. First-time test setup error

```
When I try to run <leader>xt it gives an error: "the project is missing some
details, please run Xcode build setup first." What do I do?
```

xcodebuild.nvim needs a one-time project setup (pick the scheme, the workspace, and a destination device). Claude walks you through it; you select your scheme and an iPhone simulator (e.g., iPhone 17 Pro). After that, `<leader>xt` runs your tests on the simulator from inside Neovim.

## 6. Fix the broken `?` glyphs (missing Nerd Font)

```
My status line is full of question marks instead of icons. What is this and
how do I fix it?
```

The icons need a **Nerd Font**. Claude points you to install one (the video uses **JetBrains Mono Nerd Font**) and set it as your terminal font (Terminal/iTerm → Profiles → Text → Font). Restart, and the glyphs + git branch indicator render.

## 7. Generate your own cheat sheet

```
Could you make an HTML cheat sheet of all the useful shortcuts in this setup
so I can keep it open in my browser while I learn?
```

Claude generates a standalone HTML reference (a copy lives in this folder as `cheatsheet.html`). Keep it side-by-side with the editor until the bindings are muscle memory.

---

## Why this works

Most "set up Neovim for iOS" guides hand you a 600-line `init.lua` you can't debug. This flips it: Claude knows the tools you don't, builds the config against *your* stated needs, and explains each piece — so the config grows with your understanding instead of outrunning it. When something breaks (and it will), the same back-and-forth that built it fixes it.
