# Homepage Transparent Glass Dashboard Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Transform the startpage into an ambient, transparent Gruvbox dark glass dashboard featuring live weather, clock, customizable service health pings, software release tracker, and tech/AI news dispatch, while retaining instant bang search routing.

**Architecture:** Single-file static web application (`index.html`) using semantic modern HTML, vanilla JS modules/components, and CSS glassmorphism (`backdrop-filter`, alpha variables, Gruvbox palette). External API calls (Open-Meteo, GitHub API, HN Algolia) are wrapped with localStorage TTL caching and offline fallback resilience.

**Tech Stack:** HTML5, CSS3 Glassmorphism, Vanilla ES6+ JavaScript, Open-Meteo API, GitHub Releases API, Hacker News Algolia Search API.

**Spec:** [`docs/superpowers/specs/2026-10-20-homepage-dashboard-design.md`](file:///home/sultonov/dotfiles/docs/superpowers/specs/2026-10-20-homepage-dashboard-design.md)

## Global Constraints

- Platform: Web (client-side browser startpage).
- Canvas background must be `transparent` to let Hyprland compositor blur/wallpaper show through.
- Palette: Gruvbox Dark (`#1d2021`, `#282828`, `#ebdbb2`, `#fabd2f`, `#b8bb26`, `#fe8019`, `#8ec07c`, `#d3869b`).
- Zero external runtime script/framework dependencies (vanilla JS/CSS only).
- Keyboard accessibility: `/` focuses search; bangs (`!g`, `!gh`, `!w`, `!d`) route appropriately; Enter submits.
- Configuration must be exposed in a clean, isolated `CONFIG` object at the top of the script.

## Review Focus

1. Network offline or API failure: UI gracefully renders cached values or clear fallback indicators without blanking or uncaught JavaScript exceptions.
2. CORS / opaque responses during service health pings: Local health checker handles `no-cors` or timeout gracefully without hanging the page.
3. Rapid new-tab spawning: Immediate cached render from `localStorage` without layout shift (CLS: 0) while background revalidation occurs.
4. Input focus handling: Keystroke `/` from anywhere on the page focuses search; Escape unfocuses.
5. GitHub API rate limits: Strict cache TTL checks before querying `api.github.com/repos/...` to prevent 403 rate limit locks.

---

### Task 1: Scaffolding Transparent Glass Layout & Gruvbox Design System

**Files:**
- Modify: `home/dot_config/homepage/index.html`

**Interfaces:**
- Produces: Base HTML shell, CSS custom properties (`--bg-glass`, `--border-glass`, Gruvbox colors), responsive glass grid layout (Header bar, Search input, 3-widget container), and verified transparent canvas.

- [ ] **Step 1: Write structure and CSS styles for transparent glass dashboard**
Define `--bg-glass: rgba(40, 40, 40, 0.35)`, `--border-glass: rgba(235, 219, 178, 0.1)`, `backdrop-filter: blur(20px)`, and standard Gruvbox color vars. Create structural containers: `#clock-weather-bar`, `#search-container`, `#widgets-grid` with 3 card columns.

- [ ] **Step 2: Verify markup renders cleanly and canvas remains transparent**
Run a headless validation check or static lint:
Run: `node -e 'const fs = require("fs"); const html = fs.readFileSync("home/dot_config/homepage/index.html", "utf8"); if (!html.includes("backdrop-filter") || !html.includes("transparent")) process.exit(1);'`
Expected: Clean exit code 0.

- [ ] **Step 3: Commit scaffolding**
```bash
git add home/dot_config/homepage/index.html
git commit -m "feat(homepage): setup gruvbox transparent glass layout"
```

---

### Task 2: Config System, Clock Engine & Keyboard Search Routing

**Files:**
- Modify: `home/dot_config/homepage/index.html`

**Interfaces:**
- Consumes: `#search-container`, `#clock-weather-bar`
- Produces: `window.CONFIG` object, `initClock()` timer, and `setupSearch()` keyboard listener supporting `/`, `Escape`, direct URLs, and bangs (`!g`, `!gh`, `!d`, `!w`).

- [ ] **Step 1: Define `CONFIG` schema and implement Clock & Search handlers**
Place `CONFIG` at the top of the `<script>`:
```javascript
const CONFIG = {
  weather: { city: "Tashkent", latitude: 41.2995, longitude: 69.2401 },
  services: [
    { name: "Home Assistant", url: "http://localhost:8123" },
    { name: "Syncthing", url: "http://localhost:8384" },
    { name: "Vaultwarden", url: "https://vault.local" }
  ],
  releases: [
    { name: "Neovim", repo: "neovim/neovim" },
    { name: "Hyprland", repo: "hyprwm/Hyprland" },
    { name: "Ghostty", repo: "ghostty-org/ghostty" }
  ],
  news: { maxItems: 5 }
};
```
Implement live clock ticking with `requestAnimationFrame` or `setInterval(1000)` and bang router with shortcuts.

- [ ] **Step 2: Verify bang parsing logic**
Run a node test asserting `!gh test` maps to `https://github.com/search?q=test` and `https://google.com` navigates directly.
Run: `node -e 'const html = fs.readFileSync("home/dot_config/homepage/index.html", "utf8"); if (!html.includes("!gh") || !html.includes("CONFIG")) process.exit(1);'`
Expected: Exit code 0.

- [ ] **Step 3: Commit clock and search routing**
```bash
git add home/dot_config/homepage/index.html
git commit -m "feat(homepage): add isolated CONFIG, clock, and bang search routing"
```

---

### Task 3: Weather Widget with Open-Meteo & LocalStorage Cache

**Files:**
- Modify: `home/dot_config/homepage/index.html`

**Interfaces:**
- Consumes: `CONFIG.weather`, `#weather-badge`
- Produces: `fetchWeather()` updating weather pill with condition emoji, temperature (°C), and cache TTL (15 minutes).

- [ ] **Step 1: Implement `fetchWeather()` and WMO weather code mapping**
Add WMO code dictionary (0 = Clear, 1-3 = Partly cloudy, 51-65 = Rain, 71-77 = Snow, etc.), check `localStorage.getItem("weather_cache")` before fetching `https://api.open-meteo.com/v1/forecast`, and update the UI badge seamlessly.

- [ ] **Step 2: Verify weather parser and cache TTL mechanism**
Run node assertion checking weather caching and WMO mapper functions in `index.html`.
Run: `node -e 'const html = fs.readFileSync("home/dot_config/homepage/index.html", "utf8"); if (!html.includes("open-meteo.com") || !html.includes("weather_cache")) process.exit(1);'`
Expected: Exit code 0.

- [ ] **Step 3: Commit weather widget**
```bash
git add home/dot_config/homepage/index.html
git commit -m "feat(homepage): add open-meteo weather widget with localStorage cache"
```

---

### Task 4: Service Uptime & Health Ping Widget

**Files:**
- Modify: `home/dot_config/homepage/index.html`

**Interfaces:**
- Consumes: `CONFIG.services`, `#services-widget`
- Produces: `checkServicesHealth()` pinging configured URLs with timeout (3s) and `mode: "no-cors"`, displaying pulsing green/amber/red status dots and response states.

- [ ] **Step 1: Implement asynchronous service pinging**
Use `Promise.allSettled()` with `AbortController` timeout for each entry in `CONFIG.services`. Render services list inside the glass widget with status pills and Gruvbox glowing indicator dots (`#b8bb26` up, `#fb4934` down).

- [ ] **Step 2: Verify service ping error resilience**
Ensure timeout or fetch error marks the item as down/unreachable without stopping other pings or throwing uncaught exceptions.
Run: `node -e 'const html = fs.readFileSync("home/dot_config/homepage/index.html", "utf8"); if (!html.includes("AbortController") || !html.includes("services-widget")) process.exit(1);'`
Expected: Exit code 0.

- [ ] **Step 3: Commit service uptime widget**
```bash
git add home/dot_config/homepage/index.html
git commit -m "feat(homepage): add service uptime and health ping widget"
```

---

### Task 5: Software Release Radar & Tech/AI News Dispatch

**Files:**
- Modify: `home/dot_config/homepage/index.html`

**Interfaces:**
- Consumes: `CONFIG.releases`, `CONFIG.news`, `#releases-widget`, `#news-widget`
- Produces: `fetchReleases()` (GitHub latest releases with 2h cache) and `fetchNews()` (HN Algolia AI/tech stories with 30m cache).

- [ ] **Step 1: Implement GitHub release tracker and HN Algolia wire**
Query `https://api.github.com/repos/${repo}/releases/latest` for each item in `CONFIG.releases`, caching to `localStorage`.
Query `https://hn.algolia.com/api/v1/search?tags=front_page&hitsPerPage=10` filtered for high-relevance tech/AI stories. Display clean, clickable headlines with relative time tags in Gruvbox aqua (`#8ec07c`) and purple (`#d3869b`).

- [ ] **Step 2: Verify release radar and news wire handling**
Test that empty results or rate limit headers fall back to cached data or friendly empty states.
Run: `node -e 'const html = fs.readFileSync("home/dot_config/homepage/index.html", "utf8"); if (!html.includes("hn.algolia.com") || !html.includes("releases/latest")) process.exit(1);'`
Expected: Exit code 0.

- [ ] **Step 3: Commit release radar and news dispatch**
```bash
git add home/dot_config/homepage/index.html
git commit -m "feat(homepage): add software release radar and tech/ai news wire"
```

---

### Task 6: Final Visual Polish, WCAG Contrast Check & Documentation

**Files:**
- Modify: `home/dot_config/homepage/index.html`
- Modify: `home/dot_config/homepage/PRODUCT.md`

**Interfaces:**
- Produces: Refreshed `PRODUCT.md` reflecting new dashboard capabilities, verified keyboard shortcuts, polished responsive CSS, and contrast compliance.

- [ ] **Step 1: Audit accessibility and responsive glass styling**
Ensure focus visible ring on search and news links (`outline: 2px solid var(--gruvbox-yellow)`), verify text contrast against frosted backgrounds, and ensure smooth layout at 1080p, 1440p, and 4K displays.

- [ ] **Step 2: Update `PRODUCT.md` documentation**
Document the updated dashboard features, `CONFIG` structure, API sources, and keyboard shortcuts in `PRODUCT.md`.

- [ ] **Step 3: Final validation and commit**
Test opening the dashboard locally in browser and verify zero console errors:
```bash
git add home/dot_config/homepage/index.html home/dot_config/homepage/PRODUCT.md docs/superpowers/
git commit -m "feat(homepage): complete transparent gruvbox glass dashboard"
```
