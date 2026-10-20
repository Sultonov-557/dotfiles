# Product

<!-- impeccable:product-schema 1 -->

## Platform

web

## Users

A keyboard-centric power user working across browser sessions in a tiling window manager (Hyprland / Arch Linux) with a transparent, blurred browser window, who needs an instantaneous ambient dashboard to monitor infrastructure, track software versions, read tech/AI news, and route searches rapidly without bookmark clutter.

## Product Purpose

Serve as a local, lightweight, transparent browser startpage and ambient dashboard providing real-time clock/date, live weather, configurable service health monitoring, software release tracking, tech/AI news wire, and instant keyboard search routing.

## Positioning

A zero-latency, keyboard-driven startpage committed to a cohesive Gruvbox dark glassmorphism aesthetic (`backdrop-filter: blur`), eliminating static bookmark visual noise and unnecessary telemetry while maintaining high typographic and contrast standards.

## Operating Context

- Loaded on new browser tabs as the primary entry point across desktop environments (tailored for Hyprland with transparent/blurred window rules).
- Canvas background is intentionally `transparent` to show the desktop wallpaper and compositor blur beneath.
- Interacted with predominantly via keyboard shortcuts (`/` to focus search, `Enter` to route, search bangs like `!g`, `!d`, `!gh`, `!w`).

## Key Features & Capabilities

- **Transparent Glass UI:** Frosted glass panels (`rgba(40, 40, 40, 0.38)`) with refined Gruvbox border accents and glow effects.
- **Header Bar:** Live ticking clock and date, paired with an Open-Meteo weather badge (conditions & temperature).
- **Service Uptime Monitor:** Configurable list of local/remote web services pinged asynchronously (`mode: 'no-cors'`) with live pulsing status indicators.
- **Software Release Radar:** Tracks latest releases of specified GitHub repositories with 2-hour TTL cache.
- **Tech & AI News Dispatch:** Hacker News Algolia stream highlighting top headlines with 30-minute TTL cache.
- **Isolated User Config:** Documented `CONFIG` object at the top of the script for effortless addition/removal of services, repos, and city coordinates.
- **Instant Search Routing:** Directly routes full URLs, intercepts shortcut bangs (`!g`, `!d`, `!gh`, `!w`), and defaults fallback queries to Google Search.
- **Offline & Low Latency:** Single-file distribution; all remote data caches to `localStorage` for instant paint on new tabs.

## Brand Commitments

- **Visual World:** Gruvbox Dark palette (`#1d2021` canvas, `#282828` surface, `#ebdbb2` text, `#fabd2f` yellow, `#fe8019` orange, `#b8bb26` green, `#8ec07c` aqua, `#d3869b` purple).
- **Typography:** Technical monospace and clean sans-serif pairing (`JetBrains Mono`, `Inter`, system UI font).
