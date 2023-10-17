# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

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

#
# Function to do lazy-loading of some expensive program.
# Taken from https://gist.github.com/smac89/4b85bd3f9fb902439c0e67e36272832e
#
local function lazy_load() {
    local -xr thunk="$(cat)"
    # (u) removes duplicates
    local -xr triggers=(${(u)@})

    # Only if length of triggers is greater than zero
    # otherwise the function will immediately execute.
    # (X) reports errors if any
    if [ ${(X)#triggers} -gt 0 ]; then
        eval " ${(@)triggers}() {
            trigger=\"\$0\"
            unfunction ${(@)triggers}
            ${thunk}
            if type \$trigger > /dev/null; then
                \$trigger \${@}
            fi
        }"
    fi
}

lazy_load 'pyenv' <<-'EOF'
	export PYENV_ROOT="$HOME/.pyenv"
	export PATH="$PYENV_ROOT/bin:$PATH"
	eval "$(pyenv init --path)"
	eval "$(pyenv init -)"
	eval "$(pyenv virtualenv-init -)"
	EOF

lazy_load 'sdk' 'java' 'gradle' 'mvn' 'mvnd' <<-'EOF'
	export SDKMAN_DIR=$(brew --prefix sdkman-cli)/libexec
	[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ] && source "$SDKMAN_DIR/bin/sdkman-init.sh"
	EOF

# lazy_load 'nvm' 'npm' <<-'EOF'
# 	export NVM_DIR="$HOME/.nvm"
# 	[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# 	[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
# 	EOF

lazy_load 'aws' <<-'EOF'
	autoload bashcompinit && bashcompinit
	autoload -Uz compinit && compinit
	export PATH="/Users/pierrelaporte/env/opt/aws-cli/bin:$PATH"
	complete -C '/Users/pierrelaporte/env/opt/aws-cli/aws_completer' aws
	EOF

# Delete the lazy_load function now for security purposes
unfunction lazy_load

# Override zprezto `directory` directory that prevents overwriting files
setopt clobber

# Define some aliases to very common commands
# Commands in caps can be appended at the end of other commands like `grep -v DEBUG /var/log/cassandra/system.log ELS`
alias -g EL='|& less'
alias -g ELS='|& less -S'
alias -g ELRS='|& less -RS'
alias -g ET='|& tail'
alias -g L="| less"
alias -g LRS='| less -RS'
alias -g S='| sort'
alias -g T='| tail'
alias -g US='| sort -u'
alias -g GRCB='|& grcat customs/conf.bash | less -RS'
alias -g GRCL='|& grcat customs/conf.applog | less -RS'

alias -g DSF='-u | diff-so-fancy'

alias vim=nvim
alias jiq='\jiq -q && echo'
alias dsf=diff-so-fancy
alias ls='ls --group-directories-first --color=auto --hyperlink=auto'

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

# useful only for Mac OS Silicon M1,
# still working but useless for the other platforms
# docker() {
#  if [[ `uname -m` == "arm64" ]] && [[ "$1" == "run" || "$1" == "build" ]]; then
#     /opt/homebrew/bin/docker "$1" --platform linux/amd64 "${@:2}"
#   else
#      /opt/homebrew/bin/docker "$@"
#   fi
# }

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/pierrelaporte/env/opt/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/pierrelaporte/env/opt/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/pierrelaporte/env/opt/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/pierrelaporte/env/opt/google-cloud-sdk/completion.zsh.inc'; fi

# Add user Ruby gems in the PATH
if [ -d $(find $HOME/.gem/ruby/ -maxdepth 2 -name bin -type d) ]
then
  export PATH="$(find $HOME/.gem/ruby/ -maxdepth 2 -name bin -type d):${PATH}}"
fi
