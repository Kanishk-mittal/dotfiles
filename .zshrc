# ==========================================
# 1. PATH EXPORTS
# ==========================================
export PATH=$PATH:$HOME/Applications/
export PATH=$PATH:$HOME/dotfiles/Scripts/
export PATH="/home/kanishk/.local/bin:$PATH"
export PATH="$PATH:/home/kanishk/.foundry/bin"

# Safe global npm binaries path (since you are using system Node)
export PATH="$HOME/.npm-global/bin:$PATH"

export ZSH=$HOME/.zsh
export EDITOR="/usr/bin/nano"
export TERMINAL="/usr/bin/kitty"

# Environment variables
export NODE_OPTIONS="--disable-warning=ExperimentalWarning"

# ==========================================
# 2. ZSH HISTORY CONFIG
# ==========================================
export HISTFILE=$ZSH/.zsh_history
export HISTSIZE=10000
export SAVEHIST=10000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS

# ==========================================
# 3. COMPLETIONS (Cached & Optimized)
# ==========================================
fpath=(
  /usr/share/zsh/site-functions
  /usr/share/zsh/functions/Completion
  $fpath
)

autoload -Uz compinit
# Only run compinit once every 24 hours to eliminate terminal startup lag
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # Case-insensitive matching
zstyle ':completion:*' menu select # Interactive menu selection
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# ==========================================
# 4. ALIASES & FUNCTIONS
# ==========================================
alias l="eza -lah"
alias ping="ping -c 4"
alias n="nvim"
alias nf="nvim ./"
alias ls="eza"
alias c="clear"
alias gpus='lspci -k | grep -A 2 -E "(VGA|3D)"'
alias update='yay -Syu --disable-download-timeout'
alias storage="df -h | grep 'Filesystem\|nvme'"
alias lg='lazygit'
alias searchfont='fc-list | rg -i'
alias dokcer='docker'
alias rm="rm -i"

# yazi
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

function sesh-sessions() {
  {
    exec </dev/tty
    exec <&1
    local session
    session=$(sesh list -T | fzf --height 40% --reverse --border-label ' sesh ' --border --prompt '⚡  ')
    zle reset-prompt > /dev/null 2>&1 || true
    [[ -z "$session" ]] && return
    sesh connect $session
  }
}

zle     -N             sesh-sessions
bindkey -M emacs '\es' sesh-sessions
bindkey -M vicmd '\es' sesh-sessions
bindkey -M viins '\es' sesh-sessions

# ==========================================
# 6. PLUGINS & INITS
# ==========================================
# zdharma's fast highlighting
source ~/.zsh/plugins/fsh/F-Sy-H.plugin.zsh

# zsh-users' autosuggestion
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

eval "$(zoxide init zsh)"
eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/ajb_negligible.toml)"
eval "$(atuin init zsh)"

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# ==========================================
# 7. LAZY LOAD CONDA
# ==========================================
# Conda initialization is heavy, so it only runs when you type 'conda'
conda() {
    unset -f conda
    __conda_setup="$("$HOME/miniconda3/bin/conda" 'shell.bash' 'hook' 2> /dev/null)" 
    if [ $? -eq 0 ]; then 
        eval "$__conda_setup" 
    elif [ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]; then 
        . "$HOME/miniconda3/etc/profile.d/conda.sh" 
    else 
        export PATH="$HOME/miniconda3/bin:$PATH" 
    fi 
    unset __conda_setup
    conda "$@"
}
eval "$(fnm env --use-on-cd)"
