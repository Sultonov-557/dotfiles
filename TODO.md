# Dotfiles TODO

## Status: Most planned improvements completed ✓

All dotfiles configs are **done** and setup automation has been filled in.
This file tracks remaining nice-to-haves and future ideas.

---

## 🔴 2026-07-30 — chezmoi apply wasn't installing many configured programs

User reported `noctalia-shell` and `herdr` missing after `chezmoi apply`.
Root causes turned out to be three separate, compounding bugs:

- **The 2026-07-28 AUR-section fix was incomplete.** The heading-detection
  glob `\#*AUR*` matched *any* comment line containing the substring "AUR",
  not just the real `# ── AUR ──` heading — there are ~10 such lines
  scattered through packages.txt (`# wl-screenrec  # AUR — already
  listed...`, `# via — AUR: via-bin`, `# hadolint  # AUR (hadolint-bin)...`,
  etc.). Each false trigger flips both install scripts into "AUR mode"
  until the next `──`-containing line, silently dropping every real
  official package in between. Net effect: only 163 of 199 listed
  packages were ever installed, including `wl-clipboard`, `cliphist`,
  `qbittorrent`, `khal`/`vdirsyncer`, the entire pentesting toolkit
  (`metasploit`, `nuclei`, `sherlock`, etc.), and every linter
  (`stylua`, `vale`, `yamllint`, `python-black`...) added for
  `lint.lua`/`conform.lua`. Fixed by requiring the real box-drawing `──`
  alongside "AUR" (`\#*──*AUR*`) so only the actual heading matches.
- **`run_once_install-aur-packages.sh` was never templated.** It used
  `{{ .chezmoi.sourceDir }}` but lacked the `.tmpl` extension, so chezmoi
  never rendered it — the script always saw the literal, un-substituted
  template string as its path, silently found no file there, and exited
  0 ("packages.txt not found, skipping"). No AUR package has ever
  installed via chezmoi apply on this repo. Fixed by renaming to
  `run_onchange_install-aur-packages.sh.tmpl`.
- **Both install scripts were `run_once_`**, keyed on the script's own
  content hash — independent of packages.txt. Adding a package to
  packages.txt silently did nothing on the next apply since the script
  itself hadn't changed. Renamed both to `run_onchange_*.sh.tmpl` with a
  `packages.txt hash: {{ include "packages.txt" | sha256sum }}` comment
  embedded in each, so they re-run whenever packages.txt's contents change.
- `herdr` was never actually in packages.txt (config was ported, the
  package never was) — added `herdr-bin` to the AUR section.
- `noctalia-shell` was also missing from packages.txt; README documented
  an outdated manual git-clone+`qs` step. All 4 machines are confirmed
  CachyOS, and `noctalia-shell` is a real package in the `cachyos` repo
  (not AUR) — added to the official section, README's manual step removed.

## 🔴 2026-07-28 — nixul (NixOS) parity audit

Cross-referenced every module enabled on nixul hosts `sentinel` (work PC,
current machine) and `vanguard` (home PC) against this repo, ahead of
dropping NixOS. `nomad` (old laptop) is retired and was not audited.

**Status: installation and configuration are both done for this pass.**
Installation: packages.txt + its install/enable scripts are fixed and
complete. Configuration: zellij, herdr, noctalia, opencode, aliases, and
nvim are all ported/verified (see the follow-up entry below) — only
bookmarks parity remains open.

### Fixed
- **Critical: packages.txt install scripts silently skipped ~150 lines.**
  `run_once_install-packages.sh.tmpl` stopped collecting permanently at the
  `# ── AUR ──` heading; `run_once_install-aur-packages.sh` only collected
  between that heading and the next one. Together, every package listed
  after "From old NixOS config" (gaming, comms, network tools, printing,
  web servers, AI/ML, the whole pentesting section, databases, k8s) was
  never installed by either script — regardless of the AUR-parsing fix
  earlier today. Both scripts now treat the AUR section as a bounded block
  so official packages after it still install.
- **`run_once_enable-services.sh` didn't enable most of the daemons this
  repo installs.** Added `docker`, `libvirtd`, `fail2ban`, `sshd` (all
  unambiguous unit names, safe to auto-enable). Deliberately did NOT
  add: `unbound` (binds port 53, conflicts with `adguardhome` unless scoped
  to loopback like nixul does — enable manually once configured, see
  `setup-dns` note below), `nginx`/`vaultwarden` (need real config first).
  **Related pre-existing gap, not fixed here**: `adguardhome`, `tailscale`,
  and `caddy` were already in packages.txt before this audit but are *also*
  not in the enable list — same silent-no-op class of bug, left alone
  because I can't verify their exact systemd unit names from a NixOS box
  and guessing wrong here is exactly the failure mode this fix addresses.
  Worth a manual check.
- Added ~70 packages found enabled in nix but missing here (file managers,
  terminals, dev tools, containers/VPN, self-hosted servers, etc.) — see
  packages.txt. **Every name I wasn't highly confident about is commented
  out** (`dbeaver`, `qemu-desktop`, `vaultwarden`, `sops`, `kubectl`,
  `minikube`, `kind`, the whole NVIDIA block) rather than left live,
  because `pacman -S` resolves all targets before installing any — one bad
  name fails the *entire* batch and installs nothing. Verify and uncomment
  individually on first Arch boot.
- **NVIDIA packages are commented, not installed.** packages.txt is a flat
  list with no per-host conditionals, so leaving `nvidia`/`nvidia-utils`/
  `lib32-nvidia-utils` uncommented would install them on `archbook` (AMD)
  too. They also need `[multilib]` enabled in `/etc/pacman.conf` first
  (not automated anywhere in this repo) — that's also required for Steam's
  `lib32-*` deps, so enable it before running `install-packages.sh` at all
  on `sentinel`/`vanguard`.
- Added `sentinel` as a 4th host (work PC, separate from `vanguard`/home PC)
  to `.chezmoi.toml.tmpl`, `README.md`'s host table, and the per-hostname
  monitor block in `dot_config/hypr/hyprland.lua`.
- Ported `dot_config/zellij/config.kdl` (was entirely missing — nix's
  `zellij.kdl` had no Nix-specific templating, copied verbatim) and
  `dot_config/zed/settings.json` (vim_mode + relative line numbers; skipped
  nix's `nil`/`nixd` Nix-language-server packages, not needed post-migration).
- Checked `dot_config/herdr/config.toml` against nix's version: dotfiles'
  is already ahead (workspace ops, vim-navigation integration) from
  today's earlier KEYBINDS.md work — no porting needed.

### Deliberately NOT ported (Nix-only, doesn't apply post-migration)
`core.system.nix.*` (nix.nix, documentation, nh, nix-index, nix-ld),
`nix-tree`, `nix-melt`, `deadnix`, `vulnix` — these manage/inspect the Nix
package manager itself or lint `.nix` files. `desktop.theming` (nix's
4-theme generator: catppuccin/everforest/gruvbox/nord) — this repo is
already committed to a single hardcoded Gruvbox theme by design, so no
generator is needed.

### Not a package — needs a manual/system step instead of a packages.txt line
- **multilib repo must be enabled in `/etc/pacman.conf`** before running
  `install-packages.sh` — required for `lib32-nvidia-utils`, `lib32-mesa`,
  and Steam/Proton in general. Not currently automated anywhere in this repo.
- `core.maintenance.auto-upgrade` — no Arch equivalent packaged; if wanted,
  set up a periodic `pacman -Syu` timer manually.
- `core.maintenance.journald`, `core.system.desktop.dbus` — journald/dbus
  are default systemd components on any Arch install already; nix's modules
  were just NixOS-declarative config for the same thing.
- `core.system.identity.locale` — `/etc/locale.gen` + `locale-gen`, done
  once at Arch install time, not a chezmoi concern.
- `core.system.boot.grub` — bootloader choice happens during Arch
  installation itself, before chezmoi is relevant.
- `hardware.units.cpu.{amd,intel}` — microcode package (`amd-ucode` /
  `intel-ucode`) is commented in packages.txt; uncomment the one matching
  actual CPU vendor per machine.

### Follow-up (2026-07-28, same day): nvim / noctalia / aliases / opencode ported
The four subsystems deferred above were done in a second pass. Scope was
explicitly "migrate what's enabled on sentinel + sultonov user," not build a
universal multi-theme/multi-host system — matches how the rest of this repo
already works (single Gruvbox theme, no abstraction layer).

- **Noctalia**: nix's ~20 settings files (`nix/modules/desktop/panels/
  noctalia/settings/*.nix`) turned out not to be the right diff target —
  the *live* `~/.config/noctalia/{settings,colors,plugins}.json` on this
  machine (symlinked from the nix store, generated by home-manager, then
  mutated at runtime by the app itself) is the actual fully-resolved state
  and was copied directly into `dot_config/noctalia/`. Note: the ~20
  QuickShell plugin folders under `~/.config/noctalia/plugins/*` (referenced
  by `plugins.json`) were NOT copied — they're fetched by Noctalia's own
  plugin manager from the registered GitHub source at runtime, same as how
  Noctalia itself is already documented as a manual git-clone step below.
- **opencode**: merged live `~/.config/opencode/opencode.json` (current
  agent/permission/plugin state) with dotfiles' pre-existing `config.json`
  (which already had provider configs live didn't, e.g. `litellm`). Added
  the `mcp` server block, translated from nix's `mcp-servers-nix` flake
  (nix store paths) to portable commands: `uvx mcp-server-fetch`,
  `npx @modelcontextprotocol/server-{filesystem,memory}`, `uvx
  mcp-server-git`, and a `sh -c` wrapper for `github-mcp-server` using
  `gh auth token`. Dropped `mcp-nixos` (NixOS-specific, no equivalent).
  Ported `AGENTS.md` (generalized one Nix-specific bullet under Error
  Handling) and the Gruvbox-derived TUI theme (was `themes/stylix.json`,
  nix's stylix-generated theme — copied as `themes/gruvbox.json`, referenced
  from `tui.json`, since dotfiles doesn't use stylix).
- **Aliases**: cross-referenced nix's flat alias list
  (`nix/users/sultonov/alias/default.nix`) against `dot_config/aliases/
  aliases.sh`. Most were already covered under different (usually better —
  eza-based `ls` family, `gstash*` family) names; added the ~20 genuinely
  missing ones (`dus`, `glast`, `gs`, `gdc`, `curl`/`wget` verbosity flags,
  docker `di`/`dpa`/`dex`/`dl`/`dpull`, npm/bun `nr`/`nx`/`br`/`bi`/`ba`/`bt`,
  jq `j`/`jp`/`js`, `untargz`/`untarbz2`). Dropped all Nix-package-manager
  aliases (`n`/`ni`/`ns`/`nr`/`nb`/`nl`/`no`/`nf`/`ng`/`ndc`/`niv`,
  `cleannix`). Adapted `c` (copy to clipboard) to `wl-copy` — nix used
  X11 `xclip`, this system is Wayland-only.
- **Neovim**: `dot_config/nvim` already covers most of what nixvim's ~25
  files declare (Mason-based LSP instead of nix's native lspconfig, nvim-cmp
  instead of blink-cmp, nvim-tree instead of neo-tree, alpha instead of
  snacks.dashboard — all deliberately left as-is, swapping a working plugin
  for its nix-side equivalent isn't "migrating what's enabled," it's a
  disruptive rewrite for no functional gain). Added what was genuinely
  missing as new files under `dot_config/nvim/lua/plugins/`: `supermaven`
  (AI completion), `conform` (format-on-save via dedicated formatters,
  replacing the old raw-LSP-only autocmd in `config/autocmds.lua`), `lint`
  (nvim-lint), `editing` (mini.ai + vim-surround), ts-context-commentstring
  wired into the existing `comment.lua`, `render-markdown`, `oil`,
  `diffview`, `undotree`, `kulala` (HTTP client). Added `html`/`cssls`/
  `tailwindcss`/`clangd`/`dockerls` to `lsp.lua`'s Mason `ensure_installed`.
  Added Caddyfile filetype detection to `config/options.lua`. Skipped:
  `typescript-tools.nvim` (nix prefers it over `ts_ls`, but swapping would
  mean restructuring the working Mason/lspconfig setup for equivalent
  functionality), `snacks.nvim` (dashboard/indent-scope already covered by
  alpha.nvim/indent-blankline), `noice.nvim`/`dressing.nvim`/`colorizer`/
  `mini.animate`/`barbecue`/`navic` (UI polish, subjective, not tested).
  **Theme inconsistency spotted, not fixed**: `plugins/colorscheme.lua` is a
  deeply customized Catppuccin Mocha setup (not a stray default) while the
  rest of this repo commits to Gruvbox — this one looks intentional rather
  than drift, unlike herdr/noctalia's stale theme fields, so left alone.
  Added `shellcheck`, `hadolint`, `luacheck`, `golangci-lint`, `stylua`,
  `vale`, `yamllint`, `python-black` to packages.txt so `lint.lua`/
  `conform.lua` have something to run — `prettier` isn't in official repos,
  noted as an `npm i -g prettier` install instead.
- **Critical opencode filename bug found and fixed**: `dot_config/opencode/
  config.json` had almost certainly never been loaded, ever — opencode only
  reads `opencode.json`/`opencode.jsonc` (confirmed by grepping the actual
  binary's strings for the literal filenames it looks for; `config.json`
  doesn't appear anywhere). Renamed to `dot_config/opencode/opencode.json`.
  Also changed `instructions` from `~/.config/opencode/AGENTS.md` to the
  absolute path (tilde-expansion in that field was unverified) — matches
  how the rest of this repo already assumes a single fixed user/home dir
  rather than templating it.
- **Bookmarks**: still not done —
  `nix/hosts/{sentinel,vanguard}/bookmarks.nix` feed nix's glance/dashy/
  browser bookmark adapters — check these are reflected in
  `dot_config/glance` and browser bookmarks.
- **Theme inconsistency spotted, not fixed**: `dot_config/herdr/config.toml`
  sets `theme = "catppuccin"` while the rest of this repo (and its own
  README) commits to Gruvbox. Confirm intent before changing.
- **nginx vs caddy**: nix's `services.server.nginx` does internal CA +
  wildcard cert generation and reverse-proxies the self-hosted service
  stack (vaultwarden, glance, dashy, uptime-kuma...); `dot_config/caddy`
  is currently just a placeholder. Both are now in packages.txt — decide
  whether to build out nginx's CA/cert automation here or keep caddy as
  the real reverse proxy and drop nginx to just the packages list.
- **hermes** (`services.ai.hermes`) is a custom nixul flake input
  (hermes-agent) with no Arch/AUR equivalent — evaluate an alternative
  if still wanted post-migration.

---

## 🟢 Recently completed

- [x] **Tmux dead leaf cleaned** — aliases removed, tpm script deprecated
- [x] **paru over yay** — all package aliases now use paru (matches aur-helper)
- [x] **macOS leftover** — macos-titlebar-style removed from ghostty config
- [x] **Package dedup** — pwvucontrol removed (pavucontrol kept)
- [x] **bat theme** — BAT_THEME=Gruvbox-dark in all shells + xprofile
- [x] **dot_xprofile** — created for login-manager environment
- [x] **Per-host monitor layouts** — hyprland.lua now detects hostname
- [x] **Default wallpaper script** — run_once_after downloads placeholder
- [x] **btop config** — Gruvbox-themed btop.conf + custom theme file
- [x] **wlogout config** — layout + style.css for session menu
- [x] **fastfetch config** — Gruvbox-themed config.jsonc
- [x] **~/.face avatar** — SVG placeholder deployed via chezmoi
- [x] **dot_inputrc** — readline config for bash/python REPLs
- [x] **Udiskie config** — YAML config for automount daemon
- [x] **Firefox/Zen userChrome.css** — Gruvbox browser theme + deploy script
- [x] **Systemd user services** — cliphist, hyprpaper, dunst, polkit-gnome
- [x] **Enhanced .chezmoi.toml.tmpl** — per-machine booleans (is_laptop, has_nvidia, etc.)
- [x] **Post-install checklist** — added to install.sh
- [x] **Yazi config** — full Gruvbox config (yazi.toml, keymap.toml, theme.toml, init.lua)
- [x] **DNS setup script** — setup-dns to route systemd-resolved through AdGuardHome
- [x] **GTK bookmarks** — expanded with Projects, work, chezmoi dirs
- [x] **chezmoi auto-apply** — systemd timer runs `chezmoi update --apply` every 6h
- [x] **Neovim lazy-loading** — switched from eager to lazy-by-default with proper triggers

---

## 🟡 Still outstanding

- [ ] **Swaync config** — alternative notification center for when dunst is muted

- [ ] **Hyprland windowrulev2 config migration** — some rules still in .conf (Lua API gaps), check future Hyprland releases for full Lua parity

- [ ] **Prune duplicate env vars** — Wayland vars duplicated across dot_profile, dot_xprofile, and hyprland.lua. Consider consolidating to one source of truth

---

## 🔵 Future ideas

- [ ] **Nix home-manager flake** — experimental Nix-based config alongside chezmoi
- [ ] **Neovim LSP keymap consolidation** — move remaining LSP configs into keymaps.lua
- [ ] **Multi-monitor kanshi profile** — dynamic monitor profiles for dock/undock
- [ ] **Waybar config** — alternative status bar to Noctalia bar

---

## File manifest

```
install.sh                             # Bootstrap (updated with checklist)
packages.txt                           # Package list (deduped)
scripts/
  run_onchange_install-packages.sh.tmpl     # Official pacman packages
  run_once_install-aur-helper.sh            # Install paru
  run_onchange_install-aur-packages.sh.tmpl # AUR packages
  run_once_install-tpm.sh              # Deprecated (herdr replaces tmux)
  run_once_enable-services.sh          # Enable system services
  run_once_set-default-shell.sh        # chsh to fish
  run_once_setup-xdg-dirs.sh           # Create XDG dirs
  run_once_install-cursor-theme.sh     # Bibata + Papirus
  run_once_setup-gpg.sh               # GPG agent config
  run_once_after_install-wallpaper.sh.tmpl  # NEW — download wallpaper
  run_once_after_setup-firefox-chrome.sh    # NEW — deploy browser CSS
dot_bashrc                             # Bash fallback config
dot_profile                            # Login shell env (updated)
dot_xprofile                           # NEW — X11 login env
dot_inputrc                            # NEW — readline config
dot_face                               # NEW — user avatar SVG
dot_ssh/config.tmpl                    # SSH config template
dot_gnupg/gpg-agent.conf               # GPG agent config
dot_config/
  btop/btop.conf                       # NEW — Gruvbox resource monitor
  btop/themes/gruvbox_dark.theme       # NEW — btop theme
  fastfetch/config.jsonc               # NEW — fetch config
  wlogout/layout                       # NEW — session menu layout
  wlogout/style.css                    # NEW — session menu style
  systemd/user/*.service               # NEW — user service files
  udiskie/config.yml                   # NEW — automount config
  zen/browser/chrome/userChrome.css    # NEW — browser theme
```
