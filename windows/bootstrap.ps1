$DOTFILES_PATH="${env:USERPROFILE}/.dotfiles"

#begin_include("scripts/_output.ps1")
######################################################################
#
# Output functions
#
######################################################################

function bootstrap_done() {
    Write-Host -ForegroundColor Green "`n* Bootstrap complete"
}

function fatal([string]$text) {
    Write-Host -ForegroundColor Red "!!! $text !!!"
    exit 255
}

function info([string]$text) {
    Write-Host -ForegroundColor White "$text"
}

function ok([string]$text) {
    if ($text) {
        Write-Host -ForegroundColor Green "OK ($text)"
    } else {
        Write-Host -ForegroundColor Green "OK"
    }
}

function operation([string]$text) {
    Write-Host -ForegroundColor Cyan "==> $text"
}

function operation_check_exit([string]$code, [int[]]$ignored) {
    if ($code -ne 0) {
        if ($code -in @($ignored)) {
            ok "Ignored exit code $code"
        } else {
            Write-Host -ForegroundColor Red "Operation failed with exit code $code"
            exit 255
        }
    } else {
        ok
    }
}

function operation_group([string]$name) {
    Write-Host -ForegroundColor Cyan ">`n> $name`n>"
}

function warn([string]$text) {
    Write-Host -ForegroundColor Yellow "WARN: $text"
}
#end_include()

#begin_include("scripts/_git.ps1")
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
#end_include()

operation_group "Configure dotfiles"
git_clone_dotfiles_repo $DOTFILES_PATH
git_config_include $DOTFILES_PATH/windows/.gitconfig
ok

bootstrap_done
exit 0
