# ==========================================
# 1. PATH EXPORTS & ENVIRONMENT
# ==========================================
export PATH="$PATH:$HOME/Applications/"
export PATH="$PATH:$HOME/dotfiles/Scripts/"
export PATH="/home/kanishk/.local/bin:$PATH"
export PATH="$HOME/.npm-global/bin:$PATH"

export EDITOR="/usr/bin/nano"
export TERMINAL="/usr/bin/kitty"
export NODE_OPTIONS="--disable-warning=ExperimentalWarning"

# ==========================================
# 2. BASH HISTORY CONFIG
# ==========================================
export HISTFILE="$HOME/.bash_history"
export HISTSIZE=10000
export HISTFILESIZE=10000
export HISTCONTROL=ignoreboth:erasedups
shopt -s histappend

# ==========================================
# 3. ALIASES & FUNCTIONS
# ==========================================
alias l="eza -lah"
alias n="nvim"
alias nf="nvim ./"
alias ls="eza"
alias c="clear"
alias gpus='lspci -k | grep -A 2 -E "(VGA|3D)"'
alias update='yay -Syu --disable-download-timeout'
alias storage="df -h | grep 'Filesystem\|nvme'"
alias lg='lazygit'
alias searchfont='fc-list | rg -i'

# Yazi integration
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

function dls(){
    du -shc * | sort -h
}

# Sesh sessions for Bash (using readline binding)
function sesh-sessions() {
  local session
  session=$(sesh list -T | fzf --height 40% --reverse --border-label ' sesh ' --border --prompt '⚡  ')
  if [[ -n "$session" ]]; then
    sesh connect "$session"
  fi
}
bind -x '"\es": sesh-sessions'

# ==========================================
# 5. INITS & INTEGRATIONS
# ==========================================
# Enable Bash completion
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

eval "$(zoxide init bash)"
eval "$(oh-my-posh init bash --config $HOME/.config/ohmyposh/ajb_negligible.toml)"
eval "$(atuin init bash)"

# Set up fzf key bindings and fuzzy completion for Bash
eval "$(fzf --bash)"

# ==========================================
# 6. LAZY LOAD CONDA & FNM
# ==========================================
conda() {
    unset -f conda
    __conda_setup="$('/home/kanishk/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)" 
    if [ $? -eq 0 ]; then 
        eval "$__conda_setup" 
    else 
        if [ -f "/home/kanishk/miniconda3/etc/profile.d/conda.sh" ]; then 
            . "/home/kanishk/miniconda3/etc/profile.d/conda.sh" 
        else 
            export PATH="/home/kanishk/miniconda3/bin:$PATH" 
        fi 
    fi 
    unset __conda_setup
    conda "$@"
}

eval "$(fnm env --use-on-cd)"