#
#**********************************************************************
#   Function: Show-ModulePath - Returns all paths that can contain modules.
#
#Write-Host "Define function: Get-ModulePath"

function Show-ModulePath {    
    # Get current (sub)routine name.
    #
    #$tmp = $MyInvocation.MyCommand
    #region 'Initialization.'
    [ CmdletBinding( )]
    Param(
        [ Parameter( ParameterSetName = 'Version' )]
        [ Switch ] $Version
    )
    #endregion 'Initialization.'

    #region 'First get name and return version if requested.'
    $ScriptName = [ io.path ]::GetFileNameWithoutExtension( $MyInvocation.MyCommand.Name )
    [ Version ] $ScriptVersion = '1.0.0'
    if ( $Version ) {
        Write-Verbose "$ScriptName version : $ScriptVersion"
        Return $ScriptVersion
    }
    #endregion 'First get name and return version if requested.'

    Write-Output -InputObject "$(Get-TimeStamp) $($ScriptName) Current search path for modules:"
    $Cnt = 0
    foreach ( $mypath in ( $env:PSModulePath ).Split( ";" )) {
        $Cnt++
        $CntStr = $Cnt.ToString().PadLeft(2)
        Write-Output -InputObject "`tPath $($CntStr) - $($mypath)"
    }
}
