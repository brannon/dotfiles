export TERM=xterm-256color

# Configure ls colors
if [ "$(uname)" == "Darwin" ]; then
    export LSCOLORS=Exfxcxdxbxegedabagacad
    export CLICOLOR=1
fi

if [ "$(uname)" != "Darwin" ]; then
    if [[ ! `alias` =~ "ls" ]]; then
        alias "ls=ls --color=auto"
    fi
fi

[ -f $HOME/.dotfiles/bash_prompt.sh ] && source $HOME/.dotfiles/bash_prompt.sh

# Configure bash prompt
export PROMPT_ORDER="cr user host pwd sp git lastcmd cr prompt sp"
export PROMPT_CHAR_PREFIX=
export PROMPT_CHAR_SUFFIX=
export PROMPT_CHAR_SYMBOL="\xEF\xAC\xA6"
export PROMPT_CHAR_COLOR=gray
export PROMPT_GIT_PREFIX="\xEF\x90\x98 "
export PROMPT_GIT_SUFFIX=
export PROMPT_GIT_COLOR=gray
export PROMPT_GITSTATUS_PREFIX="["
export PROMPT_GITSTATUS_SUFFIX="]"
export PROMPT_GITSTATUS_CLEAN_COLOR=green
export PROMPT_GITSTATUS_DIRTY_COLOR=red
export PROMPT_HOST_OPTS=remote
export PROMPT_HOST_PREFIX="<"
export PROMPT_HOST_SUFFIX="> "
export PROMPT_HOST_COLOR=purple
export PROMPT_LASTCMD_OPTS=error
export PROMPT_LASTCMD_PREFIX="\n"
export PROMPT_LASTCMD_SUFFIX=
export PROMPT_LASTCMD_SUCCESS_COLOR=darkgray
export PROMPT_LASTCMD_ERROR_COLOR=yellow
export PROMPT_PWD_PREFIX=
export PROMPT_PWD_SUFFIX=
export PROMPT_PWD_COLOR=brightcyan
export PROMPT_USER_OPTS=admin
export PROMPT_USER_PREFIX=
export PROMPT_USER_SUFFIX=" "
export PROMPT_USER_COLOR=yellow
export PROMPT_USER_ADMIN_PREFIX=
export PROMPT_USER_ADMIN_SUFFIX=" "
export PROMPT_USER_ADMIN_COLOR=brightred

# Configure Git bash prompt
export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWCOLORHINTS=true
export GIT_PS1_SHOWUPSTREAM=true

# Configure PYENV / RBENV
export PYENV_ROOT="$HOME/.pyenv"
export RBENV_ROOT="$HOME/.rbenv"

# Configure GOPATH
export GOROOT="/usr/local/go"
if [ ! -z $(which brew) ]; then
    GOROOT="$(brew --prefix go)/libexec"
fi

export GOPATH="$HOME/Source/go"
export EDITOR=/usr/bin/vim

if [[ -n $(which "msedit") ]]; then
    export EDITOR="msedit"
fi

if [[ -d "$GOROOT" ]]; then
    export PATH="$PATH:$GOROOT/bin"
fi

if [[ -d "$GOPATH" ]]; then
    export PATH="$PATH:$GOPATH/bin"
fi

if [[ -d "$HOME/bin" ]]; then
    export PATH="$PATH:$HOME/bin"
fi

if [[ -d "$PYENV_ROOT/bin" ]]; then
    export PATH="$PATH:$PYENV_ROOT/bin"
fi

if [[ -d "$RBENV_ROOT/bin" ]]; then
    export PATH="$PATH:$RBENV_ROOT/bin"
fi

if [[ -d "$HOME/.platformio/penv/bin" ]]; then
    export PATH="$PATH:$HOME/.platformio/penv/bin"
fi

if [[ -d "$HOME/Library/Android/sdk" ]]; then
    export ANDROID_HOME="$HOME/Library/Android/sdk"
    export PATH="$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools"
fi

if [[ -d "/usr/local/opt/curl-openssl/bin" ]]; then
    export PATH="/usr/local/opt/curl-openssl/bin:$PATH"
fi

if [[ -d "/usr/local/opt/curl/bin" ]]; then
    export PATH="/usr/local/opt/curl/bin:$PATH"
fi

git_base_path=""
if [ ! -z $(which brew) ]; then
    git_base_path="$(brew --prefix git)"
fi

if [ -f "${git_base_path}/etc/bash_completion.d/git-prompt" ]; then
    source "${git_base_path}/etc/bash_completion.d/git-prompt"
elif [ -f "${git_base_path}/etc/bash_completion.d/git-prompt.sh" ]; then
    source "${git_base_path}/etc/bash_completion.d/git-prompt.sh"
else
    echo -e "Warning: Git bash completion script not found!"
fi

set_title() {
    local TITLE=$1
    echo -ne "\033]0;$TITLE\007"
}

epoch() {
    date +%s
}

export -fn epoch
export -fn set_title
export HISTCONTROL=ignoreboth

# Enable PYENV / RBENV
if [[ ! -z $(which pyenv) ]]; then
    eval "$(pyenv init -)"
fi
if [[ ! -z $(which rbenv) ]]; then
    eval "$(rbenv init -)"
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
[ -s "$HOME/.cargo/env" ] && \. "$HOME/.cargo/env"

