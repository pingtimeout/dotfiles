# Profile startup to find long running apps
#zmodload zsh/zprof

# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="honukai"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Uncomment this to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
# DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment following line if you want to  shown in the command execution time stamp 
# in the history command output. The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|
# yyyy-mm-dd
# HIST_STAMPS="mm/dd/yyyy"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git autojump)

source $ZSH/oh-my-zsh.sh

# User configuration

# Homebrew stuff : put /usr/local/bin in front of everything else in the default path
export PATH="/usr/local/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

# export MANPATH="/usr/local/man:$MANPATH"

# # Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Enable ZSH autocomplete
autoload -Uz compinit

for dump in ~/.zcompdump(N.mh+24); do
  compinit
done

compinit -C

# Enable Bash autocomplete compatibility
autoload -U bashcompinit
bashcompinit

# Source external environment
if [ -f ~/env/env.source ]; then
    source ~/env/env.source
else
    echo "~/env/ folder not found, nothing was sourced"
fi

PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"

# Git prompt configuration
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUPSTREAM="verbose"

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

if [ -d $HOME/bin ]; then
    PATH=$PATH:$HOME/bin
fi

# Ruby Version Manager (RVM)
#if [ -d $HOME/.rvm/bin ]; then
#    PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
#fi

if [[ "$(uname)" == "Darwin" ]]; then
    # We are on Mac OSX

    # Autojump with homebrew
    if [ -f `brew --prefix`/etc/autojump.sh ]; then
        source `brew --prefix`/etc/autojump.sh
    else
        echo "You may want to install autojump from homebrew"
    fi

elif [[ "$(expr substr $(uname -s) 1 5)" == "Linux" ]]; then
    # Do something under Linux platform
elif [[ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]]; then
    # Do something under Windows NT platform
fi

alias ll='ls -lh --color'
alias diff='colordiff'

# Only load this stuff if we are running iterm, aka not csshX
if `echo $TERM_PROGRAM | grep iTerm.app >/dev/null`
then
    # Yubikey stuff
    export "GPG_TTY=$(tty)"
    export "SSH_AUTH_SOCK=${HOME}/.gnupg/S.gpg-agent.ssh"

    # Node version manager (nvm) stuff
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" --no-use # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

    # Start GPG agent if it is not already running
    /usr/local/MacGPG2/bin/gpgconf --launch gpg-agent

    # Use the pyenv provided python
    eval "$(pyenv init -)"
fi

# Complete profile
#zprof

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/plaporte/.sdkman"
[[ -s "/Users/plaporte/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/plaporte/.sdkman/bin/sdkman-init.sh"
