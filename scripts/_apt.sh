######################################################################
#
# `apt` package manager functions
#
######################################################################

apt_install() {
    local PACKAGES
    local RC
    local STATUS
    PACKAGES="$*"
    for PACKAGE in $PACKAGES; do
        operation "Install $PACKAGE"
        STATUS=$(dpkg-query --status "$PACKAGE" 2>&1)
        if [[ $STATUS == *"is not installed"* ]]; then
            SUDO apt-get install -y "$PACKAGE"
            operation_check_exit $?
        elif [[ $STATUS == *"install ok installed"* ]]; then
            ok "Package already installed"
        else
            warn "Status of package '$PACKAGE' unknown. Run 'dpkg-query --status $PACKAGE' to see status."
        fi
    done
}

apt_update() {
    SUDO apt-get update
    operation_check_exit $?
}
