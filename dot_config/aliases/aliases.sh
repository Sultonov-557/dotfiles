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
alias cd='z' # zoxide-enhanced cd (override in shell configs if absent)

# ── Listing ─────────────────────────────────────────────────────────────────
# Shell configs override these if eza is not available
alias ls='eza --icons=auto --group-directories-first'
alias l='eza --icons=auto --group-directories-first'
alias ll='eza -l --icons=auto --group-directories-first'
alias la='eza -la --icons=auto --group-directories-first'
alias lt='eza --tree --icons=auto --group-directories-first'
alias l.='eza -d .* --icons=auto'
alias lss='eza -l --sort=size --icons=auto' # sort by size
alias lst='eza -l --sort=time --icons=auto' # sort by mtime
alias lsd='eza -lD --icons=auto'            # dirs only

# ── Grep / Search ───────────────────────────────────────────────────────────
alias grep='grep --color=auto'
alias rg='rg --color=auto'
alias rgi='rg --no-ignore --hidden' # search everything
alias rgl='rg --follow'             # follow symlinks
alias ff='fd --type f'              # find files by name
alias ffd='fd --type d'             # find dirs by name
alias ffe='fd --extension'          # find by extension
alias fif='fd --type f | fzf'       # interactive file pick

# ── Git ─────────────────────────────────────────────────────────────────────
alias g='git'
alias ga='git add'
alias gc='git commit'
alias gcm='git commit -m'
alias gca='git commit --amend'
alias gcan='git commit --amend --no-edit'
alias gp='git push'
alias gpf='git push --force-with-lease'
alias gpl='git pull'
alias gst='git status'
alias gd='git diff'
alias gds='git diff --staged'
alias gdw='git diff --word-diff'
alias gb='git branch'
alias gba='git branch -a'
alias gbv='git branch -vv' # branch + tracking info
alias gl='git log --oneline --graph'
alias glg='git log --oneline --graph --all'
alias gls='git log --oneline --graph --all --simplify-by-decoration' # tags/branches
alias grh='git reset --hard'
alias grs='git reset --soft'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gco-='git checkout -' # previous branch
alias gf='git fetch'
alias gfa='git fetch --all'
alias gfp='git fetch --prune' # clean stale refs
alias gm='git merge'
alias gr='git rebase'
alias gra='git rebase --abort'
alias grc='git rebase --continue'
alias gri='git rebase -i'
alias gcp='git cherry-pick'
alias gbl='git blame'
alias gsw='git switch'
alias gcl='git clone'
alias gcl-s='git clone --depth=1 --single-branch' # shallow clone
alias gclean='git branch --merged | grep -v "\*\|main\|master" | xargs -r git branch -d'
alias gundo='git reset --soft HEAD~1' # undo last commit (keep changes)
alias gstash='git stash push'
alias gstashp='git stash pop'
alias gstashl='git stash list'
alias gstashd='git stash drop'
alias glgrep='git log --all --oneline --grep' # search commit messages
alias gdiff='git diff --no-index'             # diff non-git files

# ── Neovim ──────────────────────────────────────────────────────────────────
alias v='nvim'
alias vi='nvim'
alias vim='nvim'
alias nv='nvim'

# ── Dotfiles ────────────────────────────────────────────────────────────────
alias dot='chezmoi'
alias dota='chezmoi add'
alias dotd='chezmoi diff'
alias dotu='chezmoi update'
alias dote='chezmoi edit'
alias dotra='chezmoi re-add'
alias doto='chezmoi apply'
alias dotl='chezmoi list'                    # list managed files
alias dotst='chezmoi status'                 # check for unapplied changes
alias dotcd='cd $(chezmoi source-path)'      # jump to chezmoi source dir
alias dotc='chezmoi re-add && chezmoi apply' # commit-like workflow

# ── Systemd ──────────────────────────────────────────────────────────────────
alias sys='systemctl'
alias sysu='systemctl --user'
alias svc='sudo systemctl'    # manage system services
alias svcu='systemctl --user' # manage user services
alias sstart='sudo systemctl start'
alias sstop='sudo systemctl stop'
alias srestart='sudo systemctl restart'
alias sstatus='systemctl status'
alias senable='sudo systemctl enable'
alias sdisable='sudo systemctl disable'
alias sreload='sudo systemctl daemon-reload'
alias jc='journalctl'
alias jcf='journalctl -f'        # follow journal
alias jcu='journalctl --user -f' # follow user journal
alias jcb='journalctl -b'        # current boot

# ── System ──────────────────────────────────────────────────────────────────
# cat alias for bat handled per-shell (conditional)
alias df='df -h'
alias du='du -h'
alias du1='du -h --max-depth=1'
alias free='free -h'
alias ip='ip --color=auto'
alias mkdir='mkdir -p'
alias ping='ping -c 4'
alias rsync='rsync -avh'
alias tree='tree -C'
alias duf='duf' # modern df (if installed)
alias btop='btop'
alias uptime='uptime -p'              # pretty uptime
alias cal='cal -3'                    # 3-month calendar
alias w='who'                         # who is logged in
alias path='echo $PATH | tr ":" "\n"' # readable PATH

# ── Process / Ports ─────────────────────────────────────────────────────────
alias ports='ss -tulanp'
alias psa='ps auxf'
alias psg='ps aux | grep'
alias mem='ps aux --sort=-%mem | head -20' # top 20 by memory
alias cpu='ps aux --sort=-%cpu | head -20' # top 20 by CPU
alias kill9='kill -9'
alias pskill='pkill -9'

# ── Package Management (Arch) ───────────────────────────────────────────────
alias paru='paru'
alias pac='paru'
alias pacu='paru -Syu'
alias pacs='paru -Ss'
alias pacq='paru -Q'
alias pacr='paru -Rns'
alias pacqo='paru -Qo'    # which package owns this file
alias pacqd='paru -Qdt'   # orphaned packages
alias pacy='paru -Y'      # paru-specific (e.g. paru -Yc)
alias cleanpac='paru -Sc' # clean build cache
alias mirrors='sudo reflector --latest 10 --sort rate --save /etc/pacman.d/mirrorlist'
alias lock='sudo touch /var/lib/pacman/db.lck' # manual pacman lock
alias unlock='sudo rm /var/lib/pacman/db.lck'  # manual pacman unlock
alias why='paru -Qi'                           # package info
alias files='paru -Ql'                         # files installed by package
alias installed='paru -Qe'                     # explicitly installed
alias installed-all='paru -Qen'                # explicit + non-AUR (@ -n)

# ── Docker (if installed) ───────────────────────────────────────────────────
alias d='docker'
alias dc='docker compose'
alias dcu='docker compose up -d'
alias dcd='docker compose down'
alias dcl='docker compose logs -f'
alias dps='docker ps'
alias dprune='docker system prune -af --volumes'

# ── Archive / Compression ───────────────────────────────────────────────────
alias tarx='tar -xvf'   # extract tar
alias tarc='tar -cvf'   # create tar
alias targz='tar -czvf' # create tar.gz
alias tarbz='tar -cjvf' # create tar.bz2
alias untar='tar -xvf'
alias gz='gzip -k'     # keep original
alias gz9='gzip -9 -k' # max compression
alias ungz='gunzip -k'
alias zipp='zip -r' # recursive zip
alias unzipp='unzip'

# ── Network ──────────────────────────────────────────────────────────────────
alias myip='curl -s ifconfig.me' # public IP
alias localip="ip -br addr show | grep -E '^[^l]' | awk '{print \$1, \$3}'"
alias dns='resolvectl status'
alias listen='ss -tulpn' # what's listening
alias speedwget='wget -O /dev/null http://speedtest.tele2.net/100MB.zip'
alias flushdns='sudo resolvectl flush-caches'
alias ports-mine='ss -tulpn | grep -E ":(3000|5173|8080|8443)"' # common dev ports
alias net-int='ip link show'                                    # network interfaces

# ── Navigation QoL (from old NixOS config) ────────────────────────────────────
alias bk='cd -'            # go back to previous directory
alias e='exit'             # shortest exit
alias copy='cp -i'         # safe copy (ask before overwrite)
alias move='mv -i'         # safe move (ask before overwrite)
alias diff='diff -u'       # unified diff by default
alias tailf='tail -f'      # follow log files
alias watch='watch -n 1'   # watch every 1 second by default

# ── System Monitoring (from old NixOS config) ────────────────────────────────
alias ht='htop'            # interactive process viewer
alias pm='procs'           # modern process listing

# ── Docker extras ────────────────────────────────────────────────────────────
alias dstop='docker stop $(docker ps -q)'  # stop all running containers
