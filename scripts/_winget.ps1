######################################################################
#
# WinGet functions
#
######################################################################

function winget_install([string]$id, [bool]$interactive = $false, [string]$location = $null, [string]$custom = $null) {
    operation "Installing winget package: $id"

    $args = @(
        "install"
    )

    if ($interactive) {
        $args += @("-i")
    }

    $args += @("--id", $id)

    if ($location) {
        $args += @("--location", $location)
    }

    if ($custom) {
        $args += @("--custom", $custom)
    }

    & winget.exe @args
}
