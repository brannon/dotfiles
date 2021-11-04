######################################################################
#
# Git functions
#
######################################################################
$DOTFILES_REPO="https://github.com/brannon/dotfiles"


function git_clone_dotfiles_repo($targetPath) {
    operation "Clone dotfiles repo"
    if (Test-Path $targetPath) {
        try {
            Push-Location $targetPath
            git fetch
            git log -n 1
            git status --short --branch
            ok "Repo already cloned"
        } finally {
            Pop-Location
        }
    } else {
        git clone $DOTFILES_REPO $targetPath
        operation_check_exit $LASTEXITCODE
    }
}

function git_config_include($includeFilePath) {
    operation "Add git config include"
    git config --global include.path $includeFilePath
    operation_check_exit $LASTEXITCODE
}
