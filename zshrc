# Enable oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="lukerandall"
plugins=(git)

source $ZSH/oh-my-zsh.sh
# Load Homebrew shell integration
eval "$(/opt/homebrew/bin/brew shellenv)"

# Define the `up` command to move `n` directories higher
up () {
    COUNTER=$1
    while [[ $COUNTER -gt 0 ]]
    do
        UP="${UP}../"
        COUNTER=$(( $COUNTER -1 ))
    done
    echo "cd $UP"
    cd $UP
    UP=''
}

hr () {
    COUNTER=${1:-10}
    gseq $COUNTER | tr -d '[:digit:]'
    gseq -s'=' 80 | tr -d '[:digit:]'
    gseq $COUNTER | tr -d '[:digit:]'
}

# Define some aliases to very common commands
# Commands in caps can be appended at the end of other commands like `grep -v DEBUG /var/log/cassandra/system.log ELS`
alias -g EL='|& less'
alias -g ELRS='|& less -RS'
alias -g L="| less"
alias -g LRS='| less -RS'
alias -g S='| sort'
alias -g T='| tail'
alias -g US='| sort -u'
alias -g DSF='-u | diff-so-fancy | less -RS'

# Create aliases AFTER oh-my-zsh has been loaded so that those ones override the oh-my-zsh defaults
alias vim=nvim
alias ls='ls --group-directories-first --color=auto --hyperlink=auto'
alias ll='ls --group-directories-first --color=auto --hyperlink=auto -lh'
alias jiq='\jiq -q'
alias icat="kitten icat"

if [ -d ~/.local/bin ]; then
    # Ensure that pipx executables are accessible
    export PATH="$PATH:$HOME/.local/bin"
fi

# Bind ALT-v to enter Vi command mode edition on the current command
# Bind ALT-k to edit the previous command in history with Vi
# Bind ALT-j to edit the next command in history with Vi
vi-cmd-up-line-history() {
  zle vi-cmd-mode
  zle up-line-or-history
}
vi-cmd-down-line-history() {
  zle vi-cmd-mode
  zle down-line-or-history
}
zle -N vi-cmd-up-line-history
zle -N vi-cmd-down-line-history
bindkey "^[v" vi-cmd-mode
bindkey '^[k' vi-cmd-up-line-history
bindkey '^[j' vi-cmd-down-line-history

# Map the `s` command to Kitty ssh helper to handle terminfo mess
alias s='kitty +kitten ssh'

# Source Linuxify
if [[ -s "$HOME/.linuxify" ]]; then
  source "$HOME/.linuxify"
fi

# Increase limits to build Dremio
NOFILE=$(sysctl -n kern.maxfilesperproc)
ulimit -n $NOFILE
NOPROC=$(sysctl -n kern.maxproc)
ulimit -u $NOPROC
export PIP_NO_BINARY=grpcio,grpcio-tools

# Load asdf runtime manager
# Append completions to fpath and initialise completions with ZSH's compinit
. "$HOME/.asdf/asdf.sh"
fpath=(${ASDF_DIR}/completions $fpath)
autoload -Uz compinit && compinit

source ~/.asdf/plugins/java/set-java-home.zsh

if which ruby >/dev/null && which gem >/dev/null; then
    PATH="$(ruby -r rubygems -e 'puts Gem.user_dir')/bin:$PATH"
fi
