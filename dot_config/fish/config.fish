# =============================================================================
# config.fish — Fish shell configuration
# =============================================================================

# ── PATH ──────────────────────────────────────────────────────────────────────
fish_add_path -g ~/.local/bin
fish_add_path -g ~/.cargo/bin
fish_add_path -g ~/.npm-global/bin

# ── Environment ───────────────────────────────────────────────────────────────
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

# ── Navigation ───────────────────────────────────────────────────────────────
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
# fish's bare cd goes to $HOME; cd - works natively

# Use eza if available, fall back to ls
if command -q eza
  alias ls="eza --icons=auto --group-directories-first"
  alias ll="eza -l --icons=auto --group-directories-first"
  alias la="eza -la --icons=auto --group-directories-first"
  alias lt="eza --tree --icons=auto --group-directories-first"
  alias l.="eza -d .* --icons=auto"
else
  alias ls="ls --color=auto"
  alias ll="ls -lh"
  alias la="ls -lah"
  alias lt="ls -R"
  alias l.="ls -d .*"
end

alias grep="grep --color=auto"
alias rg="rg --color=auto"

# ── Git ───────────────────────────────────────────────────────────────────────
alias g="git"
alias ga="git add"
alias gc="git commit"
alias gcm="git commit -m"
alias gp="git push"
alias gpl="git pull"
alias gst="git status"
alias gd="git diff"
alias gds="git diff --staged"
alias gb="git branch"
alias gl="git log --oneline --graph"
alias grh="git reset --hard"
alias gco="git checkout"
alias gf="git fetch"

# ── Neovim ────────────────────────────────────────────────────────────────────
alias v="nvim"
alias vi="nvim"
alias vim="nvim"

# ── System ────────────────────────────────────────────────────────────────────
if command -q bat
  alias cat="bat --style=plain"
else
  alias cat="cat"
end
alias df="df -h"
alias du="du -h"
alias free="free -h"
alias ip="ip --color=auto"
alias mkdir="mkdir -p"
alias ping="ping -c 4"
alias rsync="rsync -avh"
alias sudo="sudo "
alias tree="tree -C"

# Process / port helpers
alias ports="ss -tulanp"
alias psa="ps auxf"
alias psg="ps aux | grep"

# ── Tmux ──────────────────────────────────────────────────────────────────────
alias tx="tmux"
alias txn="tmux new-session -s"
alias txl="tmux list-sessions"
alias txa="tmux attach -t"

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
  # Autocomplete tuning
  set -g fish_complete_path $fish_complete_path

  # Greeting
  set -g fish_greeting ""

  # Vi-style keybindings (optional — comment out for emacs mode)
  fish_vi_key_bindings
end
