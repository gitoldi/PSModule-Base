function Get-CommandVersion {
    <#
    .SYNOPSIS
    Show version of all commands in a module.

    .DESCRIPTION
    Show version of all commands in a module.
    The standard command 'Get-Command -module <module-name>' will show the same version for all.
    It is the version of the module itself.
    Check with 
    PS C:> ( Get-Module <any-import-module> ).Version

    ModuleType Version    Name             ExportedCommands
    ---------- -------    ----             ----------------
    Script     1.2.2      <module-name>    {function-1, function-2, ...}

    .EXAMPLE
    PS C:\> Get-CommandVersion -Modules <module-name1>[,<module-name2>]
    Show version of all commands in module '<module-name>'.

    Module         Command    Version Error
    ------         -------    ------- -----
    <module-name1> <function> 1.0.5
    <module-name1> <function> 1.0.2
    <module-name2> <function> 1.1.0

    .EXAMPLE
    PS C:\> $xx = Get-CommandVersion -Modules <module-name>
    Show version of all commands in module '<module-name>' and save it in a variable.

    PS C> $xx[0]

    Module        Command       Version Error
    ------        -------       ------- -----
    <module-name1> <function>   1.0.2

    .PARAMETER Version [<SwitchParameter>]
    Will show the version of the script and exit.

    .PARAMETER Modules <Array>
    An array of modules can be entered to show the version of all commands in each module.

    .INPUTS
    The defined parameters.

    .OUTPUTS
    The PSCustomObject will be shown in the default table format.

    .NOTES
    History:

    191005 MR
    - 1.2.1 Copied my personal function to this GitHub version and renamed it.

    190627 MR
    - 1.1.2 Small changes
    - 1.1.1 Removed write-host and added write-verbose in proper places.
    - 1.1.0 Added PsCustomObject.

    190605 MR
    - 1.0.3 Modified version back to 3 deep.

    190506 MR
    - 1.0.0 Created

    #>

    #Region 'Initialize.'
    [ CmdletBinding( )]

    param (
        [ Parameter( )]
        [ Switch ] $Version
        ,
        [ Parameter( )]
        [ array ] $Modules

    )
    #EndRegion 'Initialize.'

    # First get name and return version if requested.
    $ScriptName = '(F)' + [io.path]::GetFileNameWithoutExtension( $MyInvocation.MyCommand.Name )
    [ version ] $ScriptVersion = '1.2.1'
    if ( $Version ) {
        Write-Verbose "$ScriptName version : $ScriptVersion"
        Return $ScriptVersion
    }

    #Region 'Loop through modules.'
    Write-Verbose "$( Get-TimeStamp ) $( $ScriptName ) INFO Modules to test # $( $Modules.Count )"
    [ version ] $TmpVersion = '0.0.0'
    foreach ( $TmpModule in $Modules ) {
        Write-Verbose "$( Get-TimeStamp ) $( $ScriptName ) INFO Process module : $( $TmpModule )"
        [ version ] $ModVersion = ( Get-Module $TmpModule ).Version
        foreach ( $TmpCmd in ( Get-Command -Module $TmpModule )) {
            Write-Verbose "$( Get-TimeStamp ) $( $ScriptName ) ...Command : $( $TmpCmd )"
            $TmpVersion = '0.0.0'
            $TpmError = ''
            try {
                $TmpVersion = & "$( $TmpCmd.Name )" -version -ErrorAction stop -ErrorVariable $TpmErr
                #write-host "`t" $TmpCmd.Name.PadLeft( 25 ) '-' ( $TmpVersion )
            }
            catch {
                $TpmErr = $_
                $TpmError = 'Has no (proper) parameter "Version".'
                #Write-Host ( Get-TimeStamp ) $ScriptName 'ERROR Command' $TmpCmd.Name ''
                #write-host "`t" $TmpCmd.Name.PadLeft( 25 ) '-' ( $TmpVersion ) '-' $TpmError
            }
            Write-Verbose "$( Get-TimeStamp ) $( $ScriptName ) ......$( $TmpVersion ) - $( $TmpError )"
            [ PSCustomObject ] @{
                "Source (version)" = "$TmpModule ($($ModVersion ))"
                Name = $TmpCmd
                Version = $TmpVersion
                Error = $TpmError
            }
        }
        Write-Verbose "$( '-' * 60 )"
    }
    #EndRegion 'Loop through modules.'
}
