
PROMPT_COLOR_BLACK="\[$(tput dim)$(tput setaf 0)\]"
PROMPT_COLOR_RED="\[$(tput dim)$(tput setaf 1)\]"
PROMPT_COLOR_GREEN="\[$(tput dim)$(tput setaf 2)\]"
PROMPT_COLOR_YELLOW="\[$(tput dim)$(tput setaf 3)\]"
PROMPT_COLOR_BLUE="\[$(tput dim)$(tput setaf 4)\]"
PROMPT_COLOR_PURPLE="\[$(tput dim)$(tput setaf 5)\]"
PROMPT_COLOR_CYAN="\[$(tput dim)$(tput setaf 6)\]"
PROMPT_COLOR_GRAY="\[$(tput dim)$(tput setaf 7)\]"
PROMPT_COLOR_DARKGRAY="\[$(tput bold)$(tput setaf 0)\]"
PROMPT_COLOR_BRIGHTRED="\[$(tput bold)$(tput setaf 1)\]"
PROMPT_COLOR_BRIGHTGREEN="\[$(tput bold)$(tput setaf 2)\]"
PROMPT_COLOR_BRIGHTYELLOW="\[$(tput bold)$(tput setaf 3)\]"
PROMPT_COLOR_BRIGHTBLUE="\[$(tput bold)$(tput setaf 4)\]"
PROMPT_COLOR_BRIGHTPURPLE="\[$(tput bold)$(tput setaf 5)\]"
PROMPT_COLOR_BRIGHTCYAN="\[$(tput bold)$(tput setaf 6)\]"
PROMPT_COLOR_WHITE="\[$(tput bold)$(tput setaf 7)\]"
set_fore_color() {
    local COLOR_NAME=${1:-WHITE}
    COLOR_NAME=$(echo "$COLOR_NAME" | tr '[a-z]' '[A-Z]')
    COLOR_VARIABLE_NAME="PROMPT_COLOR_${COLOR_NAME}"
    echo "${!COLOR_VARIABLE_NAME}"
}

PROMPT_BGCOLOR_BLACK="\[$(tput setab 0)\]"
PROMPT_BGCOLOR_RED="\[$(tput setab 1)\]"
PROMPT_BGCOLOR_GREEN="\[$(tput setab 2)\]"
PROMPT_BGCOLOR_YELLOW="\[$(tput setab 3)\]"
PROMPT_BGCOLOR_BLUE="\[$(tput setab 4)\]"
PROMPT_BGCOLOR_PURPLE="\[$(tput setab 5)\]"
PROMPT_BGCOLOR_CYAN="\[$(tput setab 6)\]"
PROMPT_BGCOLOR_GRAY="\[$(tput setab 7)\]"
set_back_color() {
    local COLOR_NAME=$1
    COLOR_NAME=$(echo "$COLOR_NAME" | tr '[a-z]' '[A-Z]')
    COLOR_VARIABLE_NAME="PROMPT_BGCOLOR_${COLOR_NAME}"
    echo "${!COLOR_VARIABLE_NAME}"
}

PROMPT_COLOR_RESET="\[$(tput sgr0)\]"
clear_color() {
    echo "$PROMPT_COLOR_RESET"
}

render_git() {
    local git_ps1_text=$(__git_ps1 "%s" 2>&1)
    if [[ ! -z $git_ps1_text ]]; then
        local git_dirty=0
        git diff-index --quiet HEAD &>/dev/null
        if [[ $? != 0 ]]; then
            git_dirty=1
        fi

        echo -n "$(set_fore_color $PROMPT_GIT_COLOR)"
        echo -n "$PROMPT_GIT_PREFIX"
        echo -n "$(clear_color)"

        if [[ $git_dirty == 0 ]]; then
            echo -n "$(set_fore_color $PROMPT_GITSTATUS_CLEAN_COLOR)"
        else
            echo -n "$(set_fore_color $PROMPT_GITSTATUS_DIRTY_COLOR)"
        fi

        echo -n "$PROMPT_GITSTATUS_PREFIX"
        echo -n "$git_ps1_text"
        echo -n "$PROMPT_GITSTATUS_SUFFIX"
        echo -n "$(clear_color)"

        echo -n "$(set_fore_color $PROMPT_GIT_COLOR)"
        echo -n "$PROMPT_GIT_SUFFIX"
        echo -n "$(clear_color)"
    fi
}

render_host() {
    case "$PROMPT_HOST_OPTS" in
        remote | ssh)
            if [[ -z $SSH_TTY ]]; then
                return
            fi
            ;;
    esac

    echo -n "$(set_fore_color $PROMPT_HOST_COLOR)"
    echo -n "$PROMPT_HOST_PREFIX"
    echo -n "$(hostname)"
    echo -n "$PROMPT_HOST_SUFFIX"
    echo -n "$(clear_color)"
}

render_lastcmd() {
    case "$PROMPT_LASTCMD_OPTS" in
        error)
            if [[ $1 == 0 ]]; then
                return
            fi
            ;;
    esac

    local last_cmd_text
    if [[ $1 != 0 ]]; then
        echo -n "$(set_fore_color $PROMPT_LASTCMD_ERROR_COLOR)"
        last_cmd_text="warning: last exit code was $1"
    else
        echo -n "$(set_fore_color $PROMPT_LASTCMD_SUCCESS_COLOR)"
        last_cmd_text="last exit code was $1"
    fi

    echo -n "$PROMPT_LASTCMD_PREFIX"
    echo -n "$last_cmd_text"
    echo -n "$PROMPT_LASTCMD_SUFFIX"
    echo -n "$(clear_color)"
}

render_prompt() {
    echo -n "$(set_fore_color $PROMPT_CHAR_COLOR)"
    echo -n "$PROMPT_CHAR_PREFIX"
    echo -n "$PROMPT_CHAR_SYMBOL"
    echo -n "$PROMPT_CHAR_SUFFIX"
    echo -n "$(clear_color)"
}

render_pwd() {
    echo -n "$(set_fore_color $PROMPT_PWD_COLOR)"
    echo -n "$PROMPT_PWD_PREFIX"
    echo -n "\w"
    echo -n "$PROMPT_PWD_SUFFIX"
    echo -n "$(clear_color)"
}

render_user() {
    case "$PROMPT_USER_OPTS" in
        admin)
            if [[ $EUID != 0 ]]; then
                return
            fi
            ;;
    esac

    if [[ $EUID == 0 ]]; then
        echo -n "$(set_fore_color $PROMPT_USER_ADMIN_COLOR)"
        echo -n "$PROMPT_USER_ADMIN_PREFIX"
        echo -n "$(whoami)"
        echo -n "$PROMPT_USER_ADMIN_SUFFIX"
        echo -n "$(clear_color)"
    else
        echo -n "$(set_fore_color $PROMPT_USER_COLOR)"
        echo -n "$PROMPT_USER_PREFIX"
        echo -n "$(whoami)"
        echo -n "$PROMPT_USER_SUFFIX"
        echo -n "$(clear_color)"
    fi
}

set_prompt() {
    local last_exit=$?
    local part
    PS1=""
    for part in $PROMPT_ORDER; do
        case "$part" in
            cr)
                PS1+="\n"
                ;;
            git)
                PS1+=$(render_git)
                ;;
            host)
                PS1+=$(render_host)
                ;;
            lastcmd)
                PS1+=$(render_lastcmd $last_exit)
                ;;
            prompt)
                PS1+=$(render_prompt)
                ;;
            pwd)
                PS1+=$(render_pwd)
                ;;
            sp)
                PS1+=" "
                ;;
            user)
                PS1+=$(render_user)
                ;;
        esac
    done
}

export -fn set_prompt
export -fn set_fore_color
export -fn set_back_color
export -fn clear_color
export PROMPT_COMMAND='set_prompt'
