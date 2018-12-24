######################################################################
#
# Output functions
#
######################################################################

term_reset="\033[m"
text_black="\033[0;30m"
text_red="\033[0;31m"
text_green="\033[0;32m"
text_yellow="\033[0;33m"
text_blue="\033[0;34m"
text_purple="\033[0;35m"
text_cyan="\033[0;36m"
text_white="\033[0;37m"
text_light_black="\033[1;30m"
text_light_red="\033[1;31m"
text_light_green="\033[1;32m"
text_light_yellow="\033[1;33m"
text_light_blue="\033[1;34m"
text_light_purple="\033[1;35m"
text_light_cyan="\033[1;36m"
text_light_white="\033[1;37m"

bootstrap_done() {
    echo -e "${text_light_green}\n¤ Bootstrap complete${term_reset}"
}

fatal() {
    echo -e "${text_red}!!! $1 !!!${term_reset}"
    exit 255
}

info() {
    echo -e "${text_white}$1${term_reset}"
}

ok() {
    if [[ -z $1 ]]; then
        echo -e "${text_green}OK${term_reset}"
    else
        echo -e "${text_green}OK ($1)${term_reset}"
    fi
}

operation() {
    echo -e "${text_cyan}==> $1${term_reset}"
}

operation_check_exit() {
    local IGNORED
    IGNORED=${2:-}

    if [[ $1 != 0 ]]; then
        if [[ ! " ${IGNORED[@]} " =~ " $1 " ]]; then
            echo -e "${text_red}Operation failed with exit code $1${term_reset}"
            exit 255
        else
            ok "Ignored exit code $1"
        fi
    else
        ok
    fi
}

operation_group() {
    echo -e "\n${text_light_cyan}»\n» $1\n»${term_reset}"
}

warn() {
    echo -e "${text_yellow}WARN: $1${term_reset}"
}
