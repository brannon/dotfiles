export CLICOLOR=1
export TERM=xterm

# Configure PYENV
export PYENV_ROOT="$HOME/.pyenv"

# Configure GOPATH
export GOPATH="$HOME/Source/go"
export EDITOR=/usr/bin/vim

export PATH="$PATH:$GOPATH/bin:$HOME/bin:$PYENV_ROOT/bin"

# Configure Git bash prompt
export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWCOLORHINTS=true
export GIT_PS1_SHOWUPSTREAM=true

if [ -f /etc/bash_completion.d/git-prompt ]; then
	source /etc/bash_completion.d/git-prompt
fi

set_prompt()
{
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
	
	local git_dirty=0
	git diff-index --quiet HEAD &>/dev/null
	if [[ $? != 0 ]]; then
		git_dirty=1
	fi

	PS1="\n"
	PS1+="\[$text_cyan\]\w\[$term_reset\]"

	local git_ps1_text=$(__git_ps1 "%s")
	
	if [[ ! -z $git_ps1_text ]]; then
		if [[ $git_dirty == 0 ]]; then
			PS1+="\[$text_dim\]\[$text_green\]"
		else
			PS1+="\[$text_dim\]\[$text_red\]"
		fi

		PS1+="   [ \[$git_ps1_text\] ]\[$term_reset\]"
	fi

	PS1+="\n"

	if [[ $last_cmd != 0 ]]; then
		PS1+="\[$text_dim\]\[$text_yellow\]warning: last exit code was $last_cmd\[$term_reset\]\n"
	fi

	if [[ $EUID == 0 ]]; then
		PS1+="\[$text_dim\]\[$text_white\][\[$text_bold\]\[$text_red\]root\[$text_dim\]\[$text_white\]]\[$term_reset\] "
	fi

	PS1+="\[$text_dim\]\[$text_white\] \[$term_reset\]"
}

export -fn set_prompt
export PROMPT_COMMAND='set_prompt'

# Enable PYENV
eval "$(pyenv init -)"

