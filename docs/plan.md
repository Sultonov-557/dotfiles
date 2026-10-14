# Architecture & Design Blueprint: Perfect Linux Setup (Gruvbox Pixel-Art Edition)

**Status:** Draft / In-Review  
**Target OS:** CachyOS Linux (Arch-based)  
**Hardware Profile:** High refresh-rate multi-monitor setup (`sentinel`, `vanguard`, `archbook`)  
**Core Aesthetic:** Gruvbox Retro Pixel-Art (Warm earthy palette, pixel-perfect bitmap accents, cozy terminal warmth)  
**Primary Driver:** Instant Keyboard Flow State & Modular Maintainability  

---

## 1. System Philosophy & Objectives

1. **Sub-second Mind-to-Fingers Navigation**: The entire environment acts as a direct extension of muscle memory. Universal HJKL spatial orientation across Hyprland, Ghostty, Neovim, and Yazi.
2. **Warm Gruvbox Pixel-Art Aesthetic**: Cozy, earthy tones based on Gruvbox Dark (`#282828` base canvas, `#3c3836` surface, `#ebdbb2` primary text) blended with a nostalgic 16-bit / pixel-art charm. Pixel-art wallpapers, crisp bitmap/pixel UI accents, warm amber (`#fabd2f`), terracotta orange (`#fe8019`), forest aqua/green (`#b8bb26`, `#8ec07c`), and soft red (`#fb4934`). Zero eye fatigue during all-night hacking sessions.
3. **Cohesive Dank Material Shell**: A unified modern Wayland shell (DankMaterialShell running on Quickshell + Go) delivering a streamlined bar, notification center, quick settings, volume/brightness OSDs, and media controls—styled in Gruvbox Material fashion.
4. **Reproducible & Maintainable Dotfiles**: Modular chezmoi layout with clean, maintainable configuration files and zero duplicate hardcoded tokens.

---

## 2. Core Tooling & Application Stack

| Subsystem | Tool | Role & Justification |
|---|---|---|
| **Compositor / WM** | **Hyprland** (Lua config) | Wayland dynamic tiling, sub-millisecond input response, kinetic physics animations, scratchpads, pixel-styled crisp borders. |
| **Desktop Shell** | **DankMaterialShell** (Quickshell + Go) | Unified modern Wayland shell: replaces Waybar, Dunst/Mako, SwayOSD, and power menus into a GPU-accelerated QML/Go architecture themed with Gruvbox Material colors. |
| **Terminal Emulator** | **Ghostty** | Native Zig GPU acceleration, sub-millisecond input latency, native Wayland blur, Kitty graphics protocol for Yazi pixel-art previews, paired cleanly with `herdr`. |
| **Interactive Shell** | **Fish** | Blazing-fast interactive auto-suggestions, rich completions, and instant startup (~15ms) without plugin bloat. |
| **Prompt** | **Starship** | Fast Rust prompt tailored with Gruvbox symbols, pixel-styled icons/glyphs, branch status, and execution timing. |
| **Editor / IDE** | **LazyVim (Neovim)** | Keyboard-native development environment with inline image support (`image.nvim` + Kitty graphics via Ghostty), rich markdown (`render-markdown.nvim`), seamless cross-window navigation into Hyprland, and Gruvbox Material colorscheme. |
| **File Manager** | **Yazi** (TUI) + **Nautilus** (GUI) | Async Rust file manager with terminal pixel-art image previews and vim keybindings. |
| **Launcher & Command HUD** | **Vicinae** | Raycast-grade keyboard command center: unified app launching, rich clipboard history with previews, emojis, scripts, and quick calculator on `SUPER + Space` and `SUPER + C`. |
| **Dotfiles Engine** | **Chezmoi** | Declarative configuration management with templating and clean separation of secrets and machine-specific configs. |

---

## 3. Aesthetic Palette: "Gruvbox Pixel-Art"

A warm, earthy palette carefully tuned for high legibility, retro warmth, and pixel-art visuals:

```
Canvas / Deep Background:   #1d2021  (Gruvbox Dark hard / base window background)
Surface / Background Main:  #282828  (Base editor canvas, main window background)
Surface / Elevated Card:    #3c3836  (Cards, status bars, floating HUDs, popups)
Surface Highlight:          #504945  (Hovered rows, active list items, dividers)
Border Inactive:            #3c3836  (Inactive window borders, subtle separators)
Border Active:              #d79921  (Active window border, warm amber focus indicator)
Border Highlight / Alert:   #fe8019  (Urgent / focused secondary highlight)

Accents & Functional Tokens:
Gruvbox Yellow / Amber:     #fabd2f  (Primary accents, active tags, prompts)
Gruvbox Orange:             #fe8019  (Secondary alerts, git branch indicators)
Gruvbox Red:                #fb4934  (Errors, critical warnings, urgent tags)
Gruvbox Green:              #b8bb26  (Success, additions, execution timing)
Gruvbox Aqua / Teal:        #8ec07c  (Information, links, function names)
Gruvbox Blue:               #83a598  (Type names, directory labels)
Gruvbox Purple:             #d3869b  (Keywords, special symbols)

Foreground / Typography:
Text Primary (Light / Main):#ebdbb2  (Primary buffer text, high-contrast warm cream)
Text Muted (Gray):          #a89984  (Comments, line numbers, inactive labels)
Text Dim:                   #7c6f64  (Faint hints, subtle timestamps)
```

### Pixel-Art Visual Design Rules:
- **Pixel Wallpapers & Sprites**: Pair with retro pixel-art backgrounds (`pixel-galaxy.png`, `pixel-planet.png`, `pixel-prairie.jpg`, `pixel-napping.png`, `voxel-city.jpg`) from `home/Pictures/Wallpapers/`.
- **Crisp Geometry**: Window borders styled with a clean, sharp look (rounding: 4-6px or sharp corners to complement pixel aesthetics; border size: 2px with crisp Gruvbox gold `#d79921`).
- **Typography**: Crisp monospace fonts (`Fira Code`, `JetBrains Mono`, or pixel-art companion bitmap fonts where suitable) with bold glyphs.
- **Theming Strategy**: Direct, modular configuration files per application without excessive compilation layers for easy maintenance and tweaking.

---

## 4. Animation Dynamics: "Kinetic Snap"

Hyprland animations tuned for zero perceived lag while retaining tactile fluid motion:

| Element | Style / Bezier Curve | Speed / Duration | Feel & Behavior |
|---|---|---|---|
| **Windows In (Spawn)** | `overshoot` (`[0.05, 0.9, 0.1, 1.05]`) | ~180ms (`speed = 3.8`) | Pops open with a crisp, tactile snap without delaying rendering. |
| **Windows Out (Close)** | `linear` / `fastFade` | ~100ms (`speed = 1.6`) | Vanishes instantly so closed windows get out of your way immediately. |
| **Windows Move / Resize** | `snappy` (`[0.2, 0.85, 0.32, 1.0]`) | ~200ms (`speed = 3.5`) | Tiling adjustments glide smoothly with zero trailing lag. |
| **Workspaces Switch** | `slide` with `easeOutQuint` | ~220ms (`speed = 3.2`) | Moving workspaces feels like flipping through tactile index cards. |
| **Special Workspaces (Scratchpad)** | `slidevert` with `quickSpring` | ~180ms (`speed = 3.0`) | Terminal & notes drop down from top like a HUD visor, then retract instantly. |
| **Layers / Menus (Vicinae / DMS)** | `fade` + `quick` | ~120ms (`speed = 2.2`) | Menus appear as fast as your fingers hit `SUPER + Space`. |

---

## 5. Modular Hyprland Lua Architecture

Rather than a single 500+ line monolithic file, Hyprland configuration is modularized into cleanly separated single-responsibility Lua modules under `home/dot_config/hypr/`:

```
home/dot_config/hypr/
├── hyprland.lua            # Entry point loader; loads modules in strict order
└── modules/
    ├── monitors.lua        # Hostname-based monitor profiles (sentinel, vanguard, archbook)
    ├── env.lua             # Wayland environment variables & cursor scale
    ├── theme.lua           # Gruvbox borders, crisp rounding, shadows, blur
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

## 7. Extended Application Theming (Gruvbox Pixel-Art Suite)

To ensure a continuous, harmonious aesthetic across everyday desktop workflows:

1. **DankMaterialShell**:
   - Styled with Gruvbox Material dark theme (`#1d2021` / `#282828` panels, `#3c3836` modules, `#fabd2f` active indicators).
   - Pixel-art battery, volume, network, and workspace status icons.
2. **Obsidian**:
   - Integrated as a HUD scratchpad (`SUPER + A`).
   - Styled with Gruvbox dark theme (`#1d2021` canvas, `#282828` sidebar, warm amber `#fabd2f` accents, and `#ebdbb2` text).
3. **Discord (Vencord / Vesktop)**:
   - Customized with Gruvbox Dark theme CSS: replaces standard Discord purples with Gruvbox dark card backgrounds, amber/green unread pills, and earthy channel highlights.
4. **CLI Suite (Ghostty, Yazi, Btop, Fastfetch, Starship)**:
   - **Ghostty**: Gruvbox Dark theme with soft Wayland blur, crisp pixel rendering, and truecolor Kitty protocol.
   - **Yazi**: Gruvbox borders and amber selection pills with high-res pixel-art preview support.
   - **Btop**: Warm Gruvbox theme (CPU graphs shifting from aqua `#8ec07c` to amber `#fabd2f` to red `#fb4934`).
   - **Starship**: Gruvbox prompt glyphs (`❯` in amber `#fabd2f`, directories in aqua `#8ec07c`, git branch in orange `#fe8019`).

---

## 8. Implementation Roadmap

1. **Phase 1: Hyprland Modularization & Kinetic Snap**
   - Refactor `home/dot_config/hypr/` into modular files (`monitors.lua`, `env.lua`, `theme.lua`, `animations.lua`, `keybinds.lua`, `layouts.lua`, `rules.lua`).
   - Implement "Kinetic Snap" physics curves, crisp Gruvbox borders (`#d79921`), and HJKL cross-window bindings.
   - Configure scratchpads (`special:terminal` on `SUPER+S`, `special:notes` on `SUPER+A`).
2. **Phase 2: Shell & Command Layer (DankMaterialShell + Vicinae)**
   - Setup `quickshell` and DankMaterialShell with Gruvbox Material palette and pixel-styled indicators.
   - Configure Vicinae for launcher (`SUPER+Space`) and clipboard manager (`SUPER+C`) in matching Gruvbox tones.
3. **Phase 3: Terminal & Editor Flow State (Ghostty + LazyVim)**
   - Update Ghostty config to Gruvbox Dark palette with native blur.
   - Enhance LazyVim with `image.nvim`, `render-markdown.nvim`, seamless Hyprland-vim navigation, and Gruvbox Material colorscheme.
4. **Phase 4: Extended Applications & Aesthetics**
   - Apply Gruvbox Pixel-Art themes to Starship, Yazi, Btop, Obsidian, and Discord/Vesktop.
   - Configure default pixel-art wallpaper (e.g. `pixel-galaxy.png` or `pixel-planet.png`).
5. **Phase 5: Verification & Dotfiles Cleanliness**
   - Validate clean chezmoi apply, ensure zero broken symlinks, and verify sub-millisecond response across all keybindings.
