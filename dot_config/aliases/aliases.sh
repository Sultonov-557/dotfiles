# =============================================================================
# aliases.sh — Single canonical alias file
# Source directly from bash, zsh, AND fish.
# Fish parses `alias name='value'` the same way — it works natively.
# Keep entries flat: no conditionals, no shell-specific syntax.
# Shell-specific overrides go in the respective shell configs.
# =============================================================================

# ── Navigation ──────────────────────────────────────────────────────────────
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'

# ── Listing ─────────────────────────────────────────────────────────────────
# Shell configs override these if eza is not available
alias ls='eza --icons=auto --group-directories-first'
alias ll='eza -l --icons=auto --group-directories-first'
alias la='eza -la --icons=auto --group-directories-first'
alias lt='eza --tree --icons=auto --group-directories-first'
alias l.='eza -d .* --icons=auto'

# ── Grep / Search ───────────────────────────────────────────────────────────
alias grep='grep --color=auto'
alias rg='rg --color=auto'

# ── Git ─────────────────────────────────────────────────────────────────────
alias g='git'
alias ga='git add'
alias gc='git commit'
alias gcm='git commit -m'
alias gca='git commit --amend'
alias gp='git push'
alias gpf='git push --force-with-lease'
alias gpl='git pull'
alias gst='git status'
alias gd='git diff'
alias gds='git diff --staged'
alias gb='git branch'
alias gba='git branch -a'
alias gl='git log --oneline --graph'
alias glg='git log --oneline --graph --all'
alias grh='git reset --hard'
alias grs='git reset --soft'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gf='git fetch'
alias gfa='git fetch --all'
alias gm='git merge'
alias gr='git rebase'
alias gcp='git cherry-pick'
alias gbl='git blame'
alias gsw='git switch'
alias gcl='git clone'

# ── Neovim ──────────────────────────────────────────────────────────────────
alias v='nvim'
alias vi='nvim'
alias vim='nvim'

# ── Dotfiles ────────────────────────────────────────────────────────────────
alias dot='chezmoi'
alias dota='chezmoi add'
alias dotd='chezmoi diff'
alias dotu='chezmoi update'
alias dote='chezmoi edit'
# dotc uses $(...) — shell configs handle it per-shell

# ── System ──────────────────────────────────────────────────────────────────
# cat alias for bat is handled per-shell (conditional)
alias df='df -h'
alias du='du -h'
alias du1='du -h --max-depth=1'
alias free='free -h'
alias ip='ip --color=auto'
alias mkdir='mkdir -p'
alias ping='ping -c 4'
alias rsync='rsync -avh'
alias tree='tree -C'

# ── Process / Ports ─────────────────────────────────────────────────────────
alias ports='ss -tulanp'
alias psa='ps auxf'
alias psg='ps aux | grep'

# ── Tmux ────────────────────────────────────────────────────────────────────
alias tx='tmux'
alias txn='tmux new-session -s'
alias txl='tmux list-sessions'
alias txa='tmux attach -t'
alias txk='tmux kill-session -t'

# ── Package Management (Arch) ───────────────────────────────────────────────
alias pac='sudo pacman'
alias pacu='sudo pacman -Syu'
alias pacs='pacman -Ss'
alias pacq='pacman -Q'
alias pacr='sudo pacman -Rns'

# ── Safety ──────────────────────────────────────────────────────────────────
alias rm='rm -I'          # interactive on >3 files
alias cp='cp -i'
alias mv='mv -i'
alias ln='ln -i'
