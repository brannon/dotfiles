######################################################################
#
# Execution functions
#
######################################################################

SUDO() {
    local RC
    if [[ $UID == 0 ]]; then
        eval "$@"
        RC=$?
    else
        eval "sudo $@"
        RC=$?
    fi
    return $RC
}
