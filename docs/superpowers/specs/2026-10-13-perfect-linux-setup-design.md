# Architecture & Design Blueprint: Perfect Linux Setup

**Status:** Draft / In-Review  
**Target OS:** CachyOS Linux (Arch-based)  
**Hardware Profile:** High refresh-rate multi-monitor setup (`sentinel`, `vanguard`, `archbook`)  
**Core Aesthetic:** Gothic Obsidian & Crimson Sanguine (High readability, dark velvety atmosphere)  
**Primary Driver:** Instant Keyboard Flow State & Modular Maintainability  

---

## 1. System Philosophy & Objectives

1. **Sub-second Mind-to-Fingers Navigation**: The entire environment acts as a direct extension of muscle memory. Universal HJKL spatial orientation across Hyprland, Ghostty, Neovim, and Yazi.
2. **Atmospheric Gothic Red without Fatigue**: High-contrast, pitch charcoal/obsidian surfaces (`#0d0d12`) paired with velvety crimson/wine accents (`#9b182d`, `#e63b5a`) and crisp chalk-silver typography (`#e0dfdf`). Zero eye-straining red body text.
3. **Cohesive Shell & State**: A unified desktop shell handling bar, OSDs, quick settings, and notifications instead of 5 disconnected daemons.
4. **Reproducible & Maintainable Dotfiles**: Modular chezmoi layout with zero duplicate hardcoded color tokens.

---

## 2. Core Tooling & Application Stack

| Subsystem | Tool | Role & Justification |
|---|---|---|
| **Compositor / WM** | **Hyprland** (Lua config) | Wayland dynamic tiling, sub-millisecond input response, kinetic physics animations, scratchpads. |
| **Desktop Shell** | **DankMaterialShell** (Quickshell + Go) | Unified modern Wayland shell: replaces Waybar, Mako/Dunst, SwayOSD, and power menus into a GPU-accelerated QML/Go architecture. |
| **Terminal Emulator** | **Ghostty** | Native Zig GPU acceleration, sub-millisecond input latency, native Wayland blur (`background-blur-radius = 20`), Kitty graphics protocol for Yazi image previews, paired cleanly with `herdr`. |
| **Interactive Shell** | **Fish** | Blazing-fast interactive auto-suggestions, rich completions, and instant startup (~15ms) without plugin bloat. |
| **Prompt** | **Starship** | Fast Rust prompt tailored with gothic red delimiters, branch status, and execution timing. |
| **Editor / IDE** | **LazyVim (Neovim)** | Keyboard-native development environment with inline image support (`image.nvim` + Kitty graphics via Ghostty), rich markdown (`render-markdown.nvim`), seamless cross-window navigation into Hyprland, and Sanguine Obsidian highlights. |
| **File Manager** | **Yazi** (TUI) + **Nautilus** (GUI) | Async Rust file manager with terminal image previews and vim keybindings. |
| **Launcher & Command HUD** | **Vicinae** | Raycast-grade keyboard command center: unified app launching, rich clipboard history with previews, emojis, scripts, and quick calculator on `SUPER + Space` and `SUPER + C`. |
| **Dotfiles Engine** | **Chezmoi** | Declarative configuration management with templating and clean separation of secrets and machine-specific configs. |

---

## 3. Aesthetic Palette: "Sanguine Obsidian"

A refined, gothic palette designed specifically for dark environments and extended coding sessions:

```
Canvas / Deep Obsidian:    #0d0d12  (Base window background, editor canvas)
Surface / Charcoal Slate:  #14141b  (Elevated cards, status bar, floating menus)
Surface Highlight:         #1d1d26  (Active list items, hovered borders)
Border / Subtle Muted:     #2b2b38  (Inactive borders, dividers)

Crimson Accent (Primary):  #9b182d  (Active window border, focus indicator, tags)
Ruby Bright (Secondary):   #e63b5a  (Prompts, cursor, warnings, critical alerts)
Wine Glow (Tertiary):      #5e101e  (Subtle drop shadows, glow gradients)

Text / High Legibility:    #e2e2e8  (Primary buffer text, crisp and clear)
Text Muted:                #9e9eb0  (Comments, inactive labels, line numbers)
```

### Contrast & Ergonomics Rule:
- **Red is an indicator, never a reading background or paragraph text.**
- Code and documentation text stay crisp chalk/silver (`#e2e2e8`) for zero eye strain.

---

## 4. Animation Dynamics: "Kinetic Snap"

Hyprland animations tuned for zero perceived lag while retaining tactile fluid motion:

- **Windows Open/Close**: Fast cubic bezier with subtle spring deceleration (`easeOutQuint`, 250ms).
- **Workspace Switching**: Smooth horizontal slide with instant damping (speed: `3.2`, bezier: `[0.2, 0.9, 0.3, 1.0]`).
- **Layers & Popouts (DankMaterialShell / OSD)**: Fade and vertical scale (`quick`, speed: `2.0`).
- **Active Border Glow**: Soft breathing transition between inactive (`#2b2b38`) and focused crimson (`#9b182d`).

---

## 5. Modular Hyprland Lua Architecture

Rather than a single 500+ line monolithic file, Hyprland configuration is modularized into cleanly separated single-responsibility Lua modules under `home/dot_config/hypr/`:

```
home/dot_config/hypr/
├── hyprland.lua            # Entry point loader; loads modules in strict order
└── modules/
    ├── monitors.lua        # Hostname-based monitor profiles (sentinel, vanguard, archbook)
    ├── env.lua             # Wayland environment variables & cursor scale
    ├── theme.lua           # Sanguine Obsidian borders, shadows, blur, rounding
    ├── animations.lua      # Kinetic Snap beziers and physics curves
    ├── keybinds.lua        # Universal HJKL navigation, scratchpads, multimedia keys
    ├── layouts.lua         # Dwindle/Master layout behaviors and gestures
    └── rules.lua           # Window rules, floating dialogs, scratchpad styling
```

---

## 6. Keyboard Navigation Architecture (Flow Constitution)

- **Universal Axis**: `H` (Left), `J` (Down), `K` (Up), `L` (Right).
- **Modifier Hierarchy**:
  - `SUPER + [HJKL]`: Move focus between windows.
  - `SUPER + SHIFT + [HJKL]`: Move active window in layout.
  - `SUPER + CTRL + [HJKL]`: Resize active window.
  - `SUPER + [1-9]`: Instant workspace jump.
- **Scratchpad & HUD Muscle Memory**:
  - `SUPER + Return`: Primary Ghostty terminal.
  - `SUPER + S`: Toggle floating terminal scratchpad (`special:terminal`).
  - `SUPER + A`: Toggle Obsidian notes scratchpad (`special:notes`).
  - `SUPER + Space`: Toggle Vicinae app & command launcher.
  - `SUPER + C`: Toggle Vicinae clipboard manager with image previews.

---

## 6. Implementation Roadmap

1. **Step 1: Quickshell & DankMaterialShell Setup**
   - Install `quickshell` and clone/configure DankMaterialShell in `~/.config/quickshell/`.
   - Theme DankMaterialShell to match the Sanguine Obsidian color tokens.
2. **Step 2: Hyprland Modular Configuration**
   - Refactor `home/dot_config/hypr/` into clean modules: `monitors.lua`, `animations.lua`, `keybinds.lua`, `theme.lua`, `rules.lua`.
   - Implement the "Kinetic Snap" animation curves.
3. **Step 3: Terminal & Editor Gothic Theming**
   - Update Ghostty terminal palette to Sanguine Obsidian.
   - Update Starship prompt to gothic crimson symbols.
   - Align LazyVim theme / highlights for Neovim.
4. **Step 4: Verification & Dotfiles Cleanliness**
   - Ensure `chezmoi status` and `chezmoi apply` execute cleanly without orphaned files or hardcoded breakages.
