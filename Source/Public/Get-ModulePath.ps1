#
#**********************************************************************
#   Function: Get-ModulePath - Returns all paths that can contain modules.
#
#Write-Host "Define function: Get-ModulePath"
function Get-ModulePath {
    # Get current (sub)routine name.
    #
    #$tmp = $MyInvocation.MyCommand
    $cnt = 1
    foreach ( $mpad in ($env:PSModulePath).Split( ";" )) {
        Write-Host 'Path' $cnt '-' $mpad
        $cnt++
    }
}
