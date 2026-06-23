# =============================================================================
# config.fish — Fish shell configuration
# =============================================================================

# ── Shared aliases ──────────────────────────────────────────────────────────
# aliases.sh is pure alias declarations — fish parses `alias name='value'`
# natively the same as bash. Source it directly.
if test -f "$HOME/.config/aliases/aliases.sh"
  source "$HOME/.config/aliases/aliases.sh"
end

# ── Shell-specific overrides ────────────────────────────────────────────────

# cd - works natively in fish (remembers previous dir), no alias needed

# dotfiles cd (fish uses ( ) not $( ) for command substitution)
alias dotc='cd (chezmoi source-path)'

# eza fallback
if not command -q eza
  alias ls='ls --color=auto'
  alias ll='ls -lh'
  alias la='ls -lah'
  alias lt='ls -R'
  alias l.='ls -d .*'
end

# cat via bat
if command -q bat
  alias cat='bat --style=plain'
end

# ── PATH ────────────────────────────────────────────────────────────────────
fish_add_path -g ~/.local/bin
fish_add_path -g ~/.cargo/bin
fish_add_path -g ~/.npm-global/bin

# ── Environment ─────────────────────────────────────────────────────────────
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx BROWSER zen-browser
set -gx MANPAGER "nvim +Man!"
set -gx PAGER less
set -gx TERMINAL ghostty
set -gx XDG_CONFIG_HOME ~/.config

# ── Starship Prompt ──────────────────────────────────────────────────────────
if command -q starship
  starship init fish | source
end

# ── Zoxide (smart cd) ────────────────────────────────────────────────────────
if command -q zoxide
  zoxide init fish | source
end

# ── Atuin (shell history) ────────────────────────────────────────────────────
if command -q atuin
  atuin init fish | source
end

# ── Direnv (per-project env vars) ─────────────────────────────────────────
if command -q direnv
  direnv hook fish | source
end

# ── Chezmoi completions ────────────────────────────────────────────────────
if command -q chezmoi
  mkdir -p ~/.config/fish/completions
  chezmoi completion fish >~/.config/fish/completions/chezmoi.fish 2>/dev/null
end

# ── Yazi (terminal file manager) ─────────────────────────────────────────────
if command -q yazi
  function y --description "Yazi then cd to last dir"
    set tmp (mktemp -t "yazi-cwd.XXXXX")
    yazi $argv --cwd-file="$tmp"
    if set cwd (command cat -- $tmp 2>/dev/null); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
      cd -- "$cwd"
    end
    rm -f -- $tmp
  end
end

# ── Interactive session ───────────────────────────────────────────────────────
if status is-interactive
  # Greeting
  set -g fish_greeting ""

  # Vi-style keybindings
  fish_vi_key_bindings
end
