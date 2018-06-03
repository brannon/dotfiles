export CLICOLOR=1
export TERM=xterm

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

if [[ -d "$HOME/Library/Android/sdk" ]]; then
    export ANDROID_HOME="$HOME/Library/Android/sdk"
    export PATH="$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools"
fi

if [[ -d "/usr/local/opt/curl/bin" ]]; then
    export PATH="/usr/local/opt/curl/bin:$PATH"
fi

#export PATH="$PATH:$GOROOT/bin:$GOPATH/bin:$HOME/bin:$PYENV_ROOT/bin:$RBENV_ROOT/bin"

# Configure Git bash prompt
export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWCOLORHINTS=true
export GIT_PS1_SHOWUPSTREAM=true

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

export FONTAWESOME=0
if [[ ! -z $(which fc-list) ]]; then
    fc-list | grep fontawesome &>/dev/null
    if [[ $? == 0 ]]; then
        export FONTAWESOME=1
    fi
elif [[ -d $HOME/Library/Fonts ]]; then
    if [[ -f $HOME/Library/Fonts/FontAwesome.otf ]]; then
        export FONTAWESOME=1
    fi
fi

set_prompt() {
    local last_cmd=$?
    local bg_blue='$(tput setab 4)'
    local term_reset='$(tput sgr0)'
    local text_bold='$(tput bold)'
    local text_dim='$(tput dim)'
    local text_black='$(tput setaf 0)'
    local text_red='$(tput setaf 1)'
    local text_green='$(tput setaf 2)'
    local text_yellow='$(tput setaf 3)'
    local text_blue='$(tput setaf 4)'
    local text_purple='$(tput setaf 5)'
    local text_cyan='$(tput setaf 6)'
    local text_white='$(tput setaf 7)'
    local char_git=''
    local char_prompt='>'

    if [[ $FONTAWESOME == 1 ]]; then
        char_git=''
        char_prompt=''
    fi

    local git_dirty=0
    git diff-index --quiet HEAD &>/dev/null
    if [[ $? != 0 ]]; then
        git_dirty=1
    fi

    PS1="\n"

    if [[ "$SSH_TTY" != "" ]]; then
        PS1+="\[$text_purple\]<$(hostname)>\[$term_reset\] "
    fi

    PS1+="\[$text_cyan\]\w\[$term_reset\]"

    local git_ps1_text=$(__git_ps1 "%s" 2>&1)

    if [[ ! -z $git_ps1_text ]]; then
        if [[ $git_dirty == 0 ]]; then
            PS1+="\[$text_dim\]\[$text_green\]"
        else
            PS1+="\[$text_dim\]\[$text_red\]"
        fi

        PS1+=" $char_git  [ \[$git_ps1_text\] ]\[$term_reset\]"
    fi

    PS1+="\n"

    if [[ $last_cmd != 0 ]]; then
        PS1+="\[$text_dim\]\[$text_yellow\]warning: last exit code was $last_cmd\[$term_reset\]\n"
    fi

    if [[ $EUID == 0 ]]; then
        PS1+="\[$text_dim\]\[$text_white\][\[$text_bold\]\[$text_red\]root\[$text_dim\]\[$text_white\]]\[$term_reset\] "
    fi

    PS1+="\[$text_dim\]\[$text_white\]$char_prompt \[$term_reset\]"
}

set_title() {
    local TITLE=$1
    echo -ne "\033]0;$TITLE\007"
}

epoch() {
    date +%s
}

export -fn epoch
export -fn set_prompt
export -fn set_title
export HISTCONTROL=ignoreboth
export PROMPT_COMMAND='set_prompt'

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
