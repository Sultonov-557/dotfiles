# =============================================================================
# config.fish — Fish shell configuration
# =============================================================================

# ── Shared aliases ──────────────────────────────────────────────────────────
# aliases.sh is pure alias declarations — fish parses `alias name='value'`
# natively the same as bash. Source it directly.
if test -f "$HOME/.config/aliases/aliases.sh"
  source "$HOME/.config/aliases/aliases.sh"
end

# dotfiles cd (fish uses ( ) not $( ) for command substitution)
alias dotc='cd (chezmoi source-path)'

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
set -gx BAT_THEME "Catppuccin Mocha"
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

# ── FZF (fuzzy finder) keybindings ──────────────────────────────────────────
if command -q fzf
  # fzf uses fd for file search (much faster)
  set -gx FZF_DEFAULT_COMMAND "fd --type f --hidden --follow --exclude .git --exclude node_modules --exclude .venv"
  set -gx FZF_DEFAULT_OPTS "--height 60% --layout=reverse --border --inline-info
    --color=bg:#282828,bg+:#3c3836,fg:#ebdbb2,fg+:#ebdbb2
    --color=hl:#83a598,hl+:#83a598
    --color=info:#83a598,prompt:#b8bb26,pointer:#b8bb26
    --color=marker:#b8bb26,spinner:#fabd2f,header:#83a598"
  set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
  set -gx FZF_CTRL_T_OPTS "--preview 'bat --style=header,numbers --color=always {} 2>/dev/null | head -100'"
  set -gx FZF_ALT_C_COMMAND "fd --type d --hidden --follow --exclude .git --exclude node_modules"
  set -gx FZF_ALT_C_OPTS "--preview 'eza -la --icons=auto {} 2>/dev/null | head -30'"

  # Initialize fzf keybindings for fish (Ctrl+T, Ctrl+R, Alt+C)
  fzf --fish | source
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
