# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/brannon/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="spaceship"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

export TERM=xterm-256color

# Configure ls colors
if [[ "$(uname)" == "Darwin" ]]; then
    export LSCOLORS=Exfxcxdxbxegedabagacad
    export CLICOLOR=1
fi

# Ensure brew is in the path
if [[ -d "/opt/homebrew/bin" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

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

if [[ -d "/usr/local/opt/curl-openssl/bin" ]]; then
    export PATH="/usr/local/opt/curl-openssl/bin:$PATH"
fi

if [[ -d "/usr/local/opt/curl/bin" ]]; then
    export PATH="/usr/local/opt/curl/bin:$PATH"
fi

# Enable PYENV / RBENV
if [[ ! -z $(whence -p pyenv) ]]; then
    eval "$(pyenv init -)"
fi
if [[ ! -z $(whence -p rbenv) ]]; then
    eval "$(rbenv init -)"
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

export SPACESHIP_PROMPT_ORDER=(line_sep user host dir git exit_code line_sep char)
export SPACESHIP_CHAR_SYMBOL="\xEF\xAC\xA6"
export SPACESHIP_CHAR_SUFFIX=" "
export SPACESHIP_DIR_TRUNC=0
export SPACESHIP_DIR_TRUNC_REPO=false
export SPACESHIP_GIT_SYMBOL="\xEF\x90\x98"
export SPACESHIP_EXIT_CODE_SHOW="true"
export SPACESHIP_EXIT_CODE_PREFIX="\nwarning: last exit code was"
export SPACESHIP_EXIT_CODE_SUFFIX="\n"
export SPACESHIP_EXIT_CODE_SYMBOL=" "
export SPACESHIP_EXIT_CODE_COLOR="yellow"
