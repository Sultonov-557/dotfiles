---
name: Gruvbox Ambient Startpage
description: Zero-latency, keyboard-driven transparent ambient dashboard for tiling window managers
colors:
  primary: "#fabd2f"
  primary-glow: "rgba(250, 189, 47, 0.45)"
  canvas: "transparent"
  surface-glass: "rgba(40, 40, 40, 0.38)"
  surface-hover: "rgba(235, 219, 178, 0.06)"
  border-subtle: "rgba(235, 219, 178, 0.1)"
  text-primary: "#fbf1c7"
  text-body: "#ebdbb2"
  text-secondary: "#d5c4a1"
  text-muted: "#bdae93"
  text-dim: "#a89984"
  status-up: "#b8bb26"
  status-down: "#fb4934"
  status-checking: "#fabd2f"
  radar-accent: "#fe8019"
  news-accent: "#8ec07c"
  pill-accent: "#d3869b"
typography:
  display:
    fontFamily: '"JetBrains Mono", "Fira Code", ui-monospace, monospace'
    fontSize: "2.5rem"
    fontWeight: 700
    lineHeight: 1
    letterSpacing: "-0.03em"
  headline:
    fontFamily: '"JetBrains Mono", "Fira Code", ui-monospace, monospace'
    fontSize: "0.8125rem"
    fontWeight: 600
    lineHeight: 1.2
    letterSpacing: "0.08em"
  title:
    fontFamily: '"JetBrains Mono", "Fira Code", ui-monospace, monospace'
    fontSize: "0.75rem"
    fontWeight: 700
    lineHeight: 1.2
    letterSpacing: "0.1em"
  body:
    fontFamily: 'system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif'
    fontSize: "1rem"
    fontWeight: 400
    lineHeight: 1.5
    letterSpacing: "normal"
  label:
    fontFamily: '"JetBrains Mono", "Fira Code", ui-monospace, monospace'
    fontSize: "0.6875rem"
    fontWeight: 600
    lineHeight: 1
    letterSpacing: "0.02em"
rounded:
  sm: "4px"
  md: "8px"
  lg: "12px"
  xl: "14px"
  pill: "9999px"
spacing:
  xs: "4px"
  sm: "8px"
  md: "12px"
  lg: "20px"
  xl: "28px"
components:
  card:
    backgroundColor: "{colors.surface-glass}"
    rounded: "{rounded.xl}"
    padding: "20px"
  search-box:
    backgroundColor: "{colors.surface-glass}"
    rounded: "{rounded.lg}"
    padding: "14px 20px"
  badge:
    backgroundColor: "rgba(235, 219, 178, 0.08)"
    textColor: "{colors.text-muted}"
    rounded: "{rounded.sm}"
    padding: "3px 8px"
---

# Design System: Gruvbox Ambient Startpage

## Overview

**Creative North Star: "The Translucent Tiling Terminal"**

An ambient browser entry surface engineered specifically for keyboard-first developers in tiling window managers (Hyprland / Arch Linux). The canvas is intentionally transparent to expose the compositor wallpaper blur, while frosted Gruvbox glass cards float with tactile presence without visual clutter.

Every element prioritizes instant scanability: zero blocking transitions, tabular monospace figures for temporal and version stability, high-contrast typography, and strict separation between monitoring feeds and keyboard routing.

**Key Characteristics:**
- **Zero-Latency Ambient Surface:** Designed for instant new-tab paints with local-first cached telemetry.
- **Gruvbox Dark Glassmorphism:** Deep warm slate translucent cards (`rgba(40, 40, 40, 0.38)`) bound with hairline borders (`rgba(235, 219, 178, 0.1)`).
- **Tabular Monospace Precision:** Clock ticks, release tags, and shortcuts use aligned monospace figures to eliminate layout jitter.

## Colors

A warm retro-groove palette rooted in canonical Gruvbox Dark, elevated through translucent glass surfaces.

### Primary
- **Gruvbox Warm Gold** (`#fabd2f`): The dominant focal accent for search focus states, date indicators, and search trigger keys.

### Secondary
- **Gruvbox Bright Orange** (`#fe8019`): Software release radar header and tag highlights.
- **Gruvbox Aqua** (`#8ec07c`): Tech & AI live dispatch feed header.
- **Gruvbox Olive Green** (`#b8bb26`): Service uptime indicator and verified operational states.
- **Gruvbox Dusty Purple** (`#d3869b`): Release tag pill accents and software version markers.
- **Gruvbox Crimson Red** (`#fb4934`): Service down alerts and network error states.

### Neutral
- **Foreground Light** (`#fbf1c7`): Clock numerals, active headings, and emphasized data.
- **Foreground Standard** (`#ebdbb2`): Primary body text and interactive link labels.
- **Foreground Subdued** (`#d5c4a1` / `#bdae93`): Secondary labels and weather condition text.
- **Muted Stone Gray** (`#a89984`): Hacker News metadata points, time stamps, and keyboard shortcut descriptions.
- **Canvas Blur Base** (`transparent` / `rgba(40, 40, 40, 0.38)`): Ambient frosted card backdrop.

### Named Rules
**The No-Halo Rule.** Status dots and glowing accents use crisp 1px perimeter rings rather than diffuse colored drop-shadow halos.
**The Warm Hover Rule.** Interactive hover highlights use warm foreground overlays (`rgba(235, 219, 178, 0.06)`) rather than cold white washes.

## Typography

**Display Font:** JetBrains Mono (fallback: Fira Code, ui-monospace, monospace)
**Body Font:** system-ui (fallback: -apple-system, BlinkMacSystemFont, Segoe UI, sans-serif)
**Label/Mono Font:** JetBrains Mono

**Character:** Technical, utilitarian, and calm. Monospace owns metrics, code, timestamps, and controls, while system-ui provides clean, fatigue-free reading for headlines and links.

### Hierarchy
- **Display** (700, 2.5rem, 1): The live ticking digital clock, set with `tabular-nums lining-nums`.
- **Headline** (600, 0.8125rem, 1.2): Uppercase date stamp with `0.08em` tracking.
- **Title** (700, 0.75rem, 1.2): Uppercase widget titles with `0.1em` tracking and `text-wrap: balance`.
- **Body** (400, 1rem, 1.5): Global search input and standard body text.
- **Label** (600, 0.6875rem, 1): Keyboard shortcuts, version tag pills, and metadata markers.

### Named Rules
**The Tabular Stability Rule.** All numeric data, release tags, and clocks declare `font-variant-numeric: tabular-nums` to guarantee spatial stillness across updates.

## Layout

A centered single-container layout (max-width `980px`) with a clear vertical cadence of `1.25rem` (20px):

1. **Header Bar:** Clock, date, and weather pill horizontally opposed (`justify-content: space-between`).
2. **Search Prompt:** Full-width input with instant keyboard autofocus and search shortcut prompt badge.
3. **Tri-Widget Grid:** Equal-height 3-column split (`1fr 1fr 1.3fr` above 900px, collapsing to single-column under 820px) hosting Services, Releases, and News Dispatch.
4. **Shortcuts Footer:** Centered wrapped row of available keyboard search bangs.

## Elevation & Depth

Surfaces rely on frosted glass backdrop filtering (`backdrop-filter: blur(20px)`) and subtle elevation shadows (`0 12px 32px 0 rgba(0, 0, 0, 0.3)`) rather than thick borders or aggressive 3D layers.

### Shadow Vocabulary
- **Glass Card Elevation** (`box-shadow: 0 12px 32px 0 rgba(0, 0, 0, 0.3)`): Ambient depth under all floating cards.
- **Search Focus Elevation** (`box-shadow: 0 0 12px rgba(250, 189, 47, 0.2)`): Soft illumination indicating keyboard focus.

## Shapes

- **Base Cards:** `14px` border radius with hairline `1px solid rgba(235, 219, 178, 0.1)` perimeter borders.
- **Search Input:** `12px` border radius with active border transition to gold on focus.
- **Rows & List Items:** `8px` border radius for comfortable hit targets.
- **Badges & Pills:** `4px` border radius for keyboard badges; `9999px` full capsule radius for status chips and weather.

## Components

### Cards / Containers
- **Corner Style:** `14px` radius.
- **Background:** `rgba(40, 40, 40, 0.38)` with `backdrop-filter: blur(20px)`.
- **Border:** `1px solid rgba(235, 219, 178, 0.1)`, shifting to `0.2` on hover.

### Inputs / Search Field
- **Corner Style:** `12px` radius.
- **Focus:** Border transitions to `rgba(250, 189, 47, 0.45)` with ambient gold focus glow.
- **Typography:** `1rem` sans-serif with placeholder colored in `--gruv-gray`.

### Status Indicators
- **Style:** `8px` circular dot with `1px solid rgba(..., 0.4)` perimeter stroke.
- **Colors:** Green (`#b8bb26`) for Up, Red (`#fb4934`) for Down, Yellow (`#fabd2f`) for Checking.

### Chips & Version Pills
- **Style:** `0.6875rem` monospace pill with `1px` tinted border and subdued translucent background.

## Do's and Don'ts

### Do:
- **Do** declare `font-variant-numeric: tabular-nums` on all dynamic values and timestamps.
- **Do** preserve the transparent body canvas to expose compositor window blur in Hyprland.
- **Do** maintain a strict 4.5:1 minimum contrast ratio across all text and icon pairs.
- **Do** provide fallback stale data from `localStorage` whenever external APIs error or throttle.

### Don't:
- **Don't** add colored zero-offset drop-shadow halos around cards or status dots.
- **Don't** use cold white (`rgba(255, 255, 255, ...)`) for hover states; tint overlays with Gruvbox warm foreground (`rgba(235, 219, 178, ...)`).
- **Don't** introduce blocking layout shifts or multi-second entrance animations on tab opening.
