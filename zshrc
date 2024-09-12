# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Load Homebrew shell integration
eval "$(/opt/homebrew/bin/brew shellenv)"

#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Source personal files
if [ -f ~/env/env.source ]; then
    source ~/env/env.source
else
    echo "~/env/ folder not found, nothing was sourced"
fi

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

# Override zprezto `directory` directory that prevents overwriting files
setopt clobber

# Define some aliases to very common commands
# Commands in caps can be appended at the end of other commands like `grep -v DEBUG /var/log/cassandra/system.log ELS`
alias -g EL='|& less'
alias -g ELRS='|& less -RS'
alias -g L="| less"
alias -g LRS='| less -RS'
alias -g S='| sort'
alias -g T='| tail'
alias -g US='| sort -u'
alias -g DSF='-u | diff-so-fancy'

alias vim=nvim
alias bat='\bat bat --theme=Dracula'
alias dsf=diff-so-fancy
alias ls='ls --group-directories-first --color=auto --hyperlink=auto'
alias jiq='\jiq -q'

if [ -d ~/.local/bin ]; then
    # Ensure that pipx executables are accessible
    export PATH="$PATH:/Users/pierrelaporte/.local/bin"
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

# Enable GPG SSH agent for Yubikey private key support
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

PATH="/Users/pierrelaporte/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/Users/pierrelaporte/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/Users/pierrelaporte/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/Users/pierrelaporte/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/Users/pierrelaporte/perl5"; export PERL_MM_OPT;

# # >>> conda initialize >>>
# # !! Contents within this block are managed by 'conda init' !!
# __conda_setup="$('/opt/homebrew/Caskroom/miniforge/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
# if [ $? -eq 0 ]; then
#     eval "$__conda_setup"
# else
#     if [ -f "/opt/homebrew/Caskroom/miniforge/base/etc/profile.d/conda.sh" ]; then
#         . "/opt/homebrew/Caskroom/miniforge/base/etc/profile.d/conda.sh"
#     else
#         export PATH="/opt/homebrew/Caskroom/miniforge/base/bin:$PATH"
#     fi
# fi
# unset __conda_setup
# # <<< conda initialize <<<

# Load asdf runtime manager
# Append completions to fpath and initialise completions with ZSH's compinit
. "$HOME/.asdf/asdf.sh"
fpath=(${ASDF_DIR}/completions $fpath)
autoload -Uz compinit && compinit

source ~/.asdf/plugins/java/set-java-home.zsh

if which ruby >/dev/null && which gem >/dev/null; then
    PATH="$(ruby -r rubygems -e 'puts Gem.user_dir')/bin:$PATH"
fi
