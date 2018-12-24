######################################################################
#
# Git functions
#
######################################################################
DOTFILES_REPO="https://github.com/brannon/dotfiles"


git_clone_dotfiles_repo() {
    local TARGET_PATH
    TARGET_PATH=$1

    operation "Clone dotfiles repo"
    if [[ ! -d $TARGET_PATH ]]; then
        git clone $DOTFILES_REPO $TARGET_PATH
        operation_check_exit $?
    else
        (cd $TARGET_PATH && git fetch && git log -n 1 && git status --short --branch)
        ok "Repo already cloned"
    fi
}

git_config_include() {
    local INCLUDE_FILE_PATH
    INCLUDE_FILE_PATH=$1

    operation "Add git config include"
    git config --global include.path $INCLUDE_FILE_PATH
    operation_check_exit $?
}
