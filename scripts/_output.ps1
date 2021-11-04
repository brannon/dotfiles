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
