export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="lukerandall"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

zstyle ':omz:update' mode auto      # update automatically without asking

# Uncomment the following line to change how often to auto-update (in days).
zstyle ':omz:update' frequency 7

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git autojump asdf)

source $ZSH/oh-my-zsh.sh

# User configuration

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Load Homebrew shell integration
eval "$(/opt/homebrew/bin/brew shellenv)"

# The `up` command moves `n` directories higher
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

# The `hr` command creates some space
hr () {
    COUNTER=${1:-10}
    gseq $COUNTER | tr -d '[:digit:]'
    gseq -s'=' 80 | tr -d '[:digit:]'
    gseq $COUNTER | tr -d '[:digit:]'
}

mkdirtoday() {
  current_date=$(date '+%Y-%m-%d')
  if [ -z "$1" ]; then
    echo "Missing argument: FOLDER_NAME">&2
    return 1
  fi
  mkdir "${current_date}-$1"
}

# The git-fetch-pr command moves HEAD to the head of a given PR in `origin` or `upstream`
git-fetch-pr() {
  if [ -n "$1" ]
  then
    git fetch $(git remote | grep -E 'upstream|origin') \
      && git fetch $(git remote | grep -E 'upstream|origin') pull/$1/head \
      && git checkout FETCH_HEAD \
      && hr 1 \
      && git tree | head -n 30 \
      && hr 1 \
      && git log -1
  fi
}

# Define some aliases to variants of `less`
alias -g EL='|& less'
alias -g ELRS='|& less -RS'
alias -g L="| less"
alias -g LRS='| less -RS'

# Some tmux and treehouse helpers
alias tat='tmux attach -t'
tnew() {
  if [ -z "$1" ]
  then
    session_name=$(basename "$PWD")
  else
    session_name="$1"
  fi
  tmux new-session -s "$session_name" -c "$PWD"
}
alias th='treehouse'
thcd() {
  cd "$(treehouse ls | grep "$1" | grep 'Path:' | awk '{print $2}' | sed 's/\x1b\[[0-9;]*m//g')"
}

alias pbc=pbcopy
alias grip='\grip -b'

# Create aliases AFTER oh-my-zsh has been loaded so that those ones override the oh-my-zsh defaults
alias vim=nvim
alias ls='ls --group-directories-first --color=auto --hyperlink=auto'
alias ll='ls --group-directories-first --color=auto --hyperlink=auto -lh'

# Bin CTRL-g to enter Vi command mode edition on the current command
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^G' edit-command-line

# Ensure that pipx executables are accessible
if [ -d ~/.local/bin ]; then
    export PATH="$PATH:$HOME/.local/bin"
fi

# Map the `s` command to Kitty ssh helper to handle terminfo mess
alias s='kitty +kitten ssh'

# Source Linuxify so that GNU binaries are first in PATH
if [[ -s "$HOME/.linuxify" ]]; then
  source "$HOME/.linuxify"
fi

# Autoenv should source .env at dir entry and .env.leave at dir exit
AUTOENV_ENABLE_LEAVE=1
source $(brew --prefix autoenv)/activate.sh

# Allow wildcards to resolve to nothing without erroring out
setopt NULL_GLOB

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
# pnpm end

# Force homebrew to put applications in ~/Applications/ instead of /Applications/
# That way, homebrew does not require root privileges.
export HOMEBREW_CASK_OPTS="--appdir=~/Applications"

# Load asdf and ensure runtimes are available and set JAVA_HOME
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
source ~/.asdf/plugins/java/set-java-home.zsh
