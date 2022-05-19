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

# Lazy load pyenv
lazy_load 'pyenv' <<-'EOF'
	export PYENV_ROOT="$HOME/.pyenv"
	export PATH="$PYENV_ROOT/bin:$PATH"
	eval "$(pyenv init --path)"
	eval "$(pyenv init -)"
	eval "$(pyenv virtualenv-init -)"
	EOF

lazy_load 'sdk' 'java' 'gradle' 'mvn' 'mvnd' <<-'EOF'
	export SDKMAN_DIR="${HOME}/.sdkman"
	[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ] && source "$SDKMAN_DIR/bin/sdkman-init.sh"
	EOF

# Delete the lazy_load function now for security purposes
unfunction lazy_load

# Define some aliases to very common commands
alias -g EL='|& less'
alias -g ELS='|& less -S'
alias -g ET='|& tail'
alias -g L="| less"
alias -g LL="2>&1 | less"
alias -g S='| sort'
alias -g T='| tail'
alias -g US='| sort -u'

