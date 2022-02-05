######################################################################
#
# `brew` package manager functions
#
######################################################################

brew_bootstrap() {
    operation "Ensure Homebrew is installed"
    if [ -z $(which brew) ]; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        operation_check_exit $?
    else
        ok
    fi
}

brew_install() {
    local PACKAGES
    local INFO
    PACKAGES="$*"
    for PACKAGE in $PACKAGES; do
        operation "Install $PACKAGE"
        INFO=$(brew info $PACKAGE)
        if [[ $INFO == *"Not installed"* ]]; then
            brew install $PACKAGE
            operation_check_exit $?
        elif [[ $INFO == *"Poured from bottle"* ]]; then
            ok "Package already installed"
        else
            warn "Status of package '$PACKAGE' unknown. Run 'brew info $PACKAGE' to see status."
        fi
    done
}

brew_update() {
    operation "Update Homebrew recipes"
    brew update
    operation_check_exit $?
}
