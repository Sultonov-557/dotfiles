# Homepage Dashboard Design

## Intent & Why
The user is a keyboard-centric power user working in a tiling window manager (Hyprland / Arch Linux) with a transparent, blurred browser window. The current homepage is cluttered with bookmark links that are obsolete for keyboard navigation. 

The goal is to transform the startpage into an information-dense, beautiful, transparent Gruvbox-themed dashboard that provides real-time ambient awareness across daily tools, self-hosted services, and industry tech/AI news, while preserving fast keyboard navigation (search routing and bangs).

## Goals
1. **Transparent Gruvbox Glass Aesthetics:** Seamless blend with the compositor's transparent/blurred desktop environment using `backdrop-filter: blur`, subtle translucent surfaces (`rgba(40,40,40,0.35)`), and Gruvbox dark accents.
2. **Ambient Status Widgets:**
   - **Clock & Date:** High-contrast display with live local time.
   - **Live Weather:** Local temperature, conditions, and weather icon without requiring proprietary API keys (e.g. Open-Meteo or wttr.in).
   - **Service Uptime / Health Monitor:** Easily configurable list of HTTP endpoints or local ports checked client-side, showing green/amber/red status indicators.
   - **Software Release Radar:** Configurable list of software apps/repos (e.g., GitHub releases or package versions) displaying the latest tag/release date.
   - **Tech & AI Dispatch:** Live stream of headlines from Hacker News (Algolia API) and curated tech/AI feeds.
3. **Keyboard-Driven Search:**
   - `/` shortcut focuses the search prompt instantly.
   - Retain bang query redirection (`!g`, `!gh`, `!w`, `!d`) and direct URL routing.
4. **Simple User Configuration:**
   - Transparently defined configuration object or JSON block at the top of the file / config script so the user can easily adjust their monitored apps, GitHub repos, city location, and feeds.
5. **Zero-Build & Offline Graceful Degradation:**
   - Single-file architecture (or standalone zero-dependency scripts/files) requiring no build step or node daemon to view.
   - Caches external fetch results to `localStorage` with TTL to prevent rate limits and handle offline launches smoothly.

## Non-Goals & Anti-Goals
- **No Heavy Bookmarks Bar:** No static link grids or bloated icon sets cluttering the canvas.
- **No Heavy Frameworks or Build Steps:** No React/Webpack/Vite build steps. Keep it vanilla HTML/CSS/JS so it launches instantaneously with zero start lag.
- **No Intrusive Modals / Visual Noise:** No distracting animations or intrusive popups that break the calm Gruvbox aesthetic.
- **No Mandatory External API Keys:** Weather, releases, and news must function without requiring paid or gated API tokens.

## Architecture & How It Gets Made
- **File Location:** Maintained directly in `home/dot_config/homepage/index.html`.
- **Styling:** CSS variables matching the canonical Gruvbox dark theme (`#1d2021`, `#282828`, `#ebdbb2`, `#fabd2f`, `#b8bb26`, `#fe8019`, `#8ec07c`, `#d3869b`), with alpha-transparency layers for Hyprland window blur.
- **Data Fetching:**
  - *Weather:* Open-Meteo client-side JSON API (free, open, no key, HTTPS).
  - *Tech & AI News:* Hacker News Algolia Search API (`https://hn.algolia.com/api/v1/search?tags=front_page`) filtered/curated for tech/AI headlines.
  - *Software Releases:* Public GitHub Releases API (`https://api.github.com/repos/{owner}/{repo}/releases/latest`) for user-specified repositories.
  - *Service Uptime:* Client-side `fetch` with `mode: 'no-cors'` or standard `fetch` ping with timeout handling.
  - *Storage/Cache:* Results cached in browser `localStorage` with configurable refresh intervals (e.g., weather 15m, news 30m, releases 2h) to avoid rate limits and provide instant cached paint on new tab launch.

## Configurable User Section
A clean, documented configuration block in JS:
```javascript
const CONFIG = {
  weather: {
    city: "Tashkent",
    latitude: 41.2995,
    longitude: 69.2401,
  },
  services: [
    { name: "Home Assistant", url: "http://localhost:8123" },
    { name: "Vaultwarden", url: "https://vault.local" },
    { name: "Syncthing", url: "http://localhost:8384" }
  ],
  releases: [
    { name: "Neovim", repo: "neovim/neovim" },
    { name: "Hyprland", repo: "hyprwm/Hyprland" },
    { name: "Ghostty", repo: "ghostty-org/ghostty" }
  ],
  news: {
    sources: ["hn_ai_tech"],
    maxItems: 5
  }
};
```

## What's Left to the Builder
- Detailed UI micro-interactions (e.g. keyboard navigation between items, copy link or open on enter).
- Error state styling when an API is unreachable or offline.
- Fallback coordinates auto-detection or manual default.
