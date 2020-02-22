Function Get-Uptime {
    <#
    .SYNOPSIS
    Return the uptime as a time string.

    .DESCRIPTION
    Return the uptime as a time string. The output can be used for follow up actions or just to display.
    The boot time can be found class Win32_OperatingSystem property LastBootUpTime.
    Substract that from the current date/time and you have the uptime.

    .EXAMPLE
    PS C:\> <example usage>
    Explanation of what the example does

    .INPUTS
    None

    .OUTPUTS
    Returns a time string with the uptime.

    .NOTES
    Author      : Marcel Rijsbergen
    History:

    200221 MR
    - 1.0.4 Added 'Region' and 'EndRegion'.

    200221 MR
    - 1.0.3 Added parameter 'Show' to display a formatted uptime.
            Added 'Get-TimeStamp' to output.
            Added several 'Write-Verbose'.

    190512 MR
    - 1.0.2 Moved from module MarcelRijsbergen to Tools. Version 1 up.
            Modified write-host to write-verbose. Only display data if requested.
            And just return the information to the pipeline. (don't kill the puppies)
    #>

    #Region 'Initialization.'

    # Source for requires:
    #   https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_requires?view=powershell-7
    #NotRequires -Assembly { <Path to .dll> | <.NET assembly specification> }
    #NotRequires -Modules { <Module-Name> | <Hashtable> }
    #NotRequires -PSEdition Core,Desktop
    #NotRequires -PSSnapin <PSSnapin-Name> [-Version <N>[.<n>]]
    #NotRequires -RunAsAdministrator
    #NotRequires -ShellId <ShellId> -PSSnapin <PSSnapin-Name> [-Version <N>[.<n>]]
    #NotRequires -Version <N>[.<n>]

    [ CmdletBinding( )]

    param (
        [ Parameter( )]
        [ Switch ] $Version
        ,
        [ Parameter( )]
        [ Switch ] $Show
    )

    # First get name and return version if requested.
    $ScriptName = '(F)' + [io.path]::GetFileNameWithoutExtension( $MyInvocation.MyCommand.Name )
    [ version ] $ScriptVersion = '1.0.4'
    if ( $Version ) {
        Write-Verbose "$( Get-TimeStamp ) $ScriptName INFO Version : $ScriptVersion"
        Return $ScriptVersion
    }
    #EndRegion 'Initialization.'
    
    #Region 'Get system uptime.'
    Write-Verbose "$( Get-TimeStamp ) $ScriptName INFO Get Win32_OperatingSystem property LastBootTime."
    $LastBoot = ( Get-CimInstance Win32_OperatingSystem ).LastBootUpTime
    Write-Verbose "$( Get-TimeStamp ) $ScriptName INFO Calculate the difference between 'Now' and 'LastBootTime'."
    $GetUptime = ( get-date ) - ( $LastBoot )
    #EndRegion 'Get system uptime.'

    #Region 'Show uptime if requested.'
    if ( $Show ) {
        Write-Verbose "$( Get-TimeStamp ) $ScriptName INFO Parameter 'Show' is requested. Create and show 'Uptime' as a string."
        $CurDays = $GetUptime.Days
        $CurHours = $GetUptime.Hours
        $CurMinutes = $GetUptime.Minutes

        # Check days.
        Write-Verbose "$( Get-TimeStamp ) $ScriptName INFO Check if 'day' # is below 10."
        if ( $CurDays -eq 1 ) {
            $TmpTxt = '' + $CurDays + ' day '
        }
        else {
            $TmpTxt = '' + $CurDays + ' days '
        }

        # Check hours.
        Write-Verbose "$( Get-TimeStamp ) $ScriptName INFO Check if 'hour' # is below 10."
        if ( $CurHours -eq 1 ) {
            $TmpTxt = $TmpTxt + $CurHours + ' hour '
        }
        else {
            $TmpTxt = $TmpTxt + $CurHours + ' hours '
        }

        Write-Verbose "$( Get-TimeStamp ) $ScriptName INFO Check if 'minute' # is below 10."
        # Check minutes.
        if ( $CurMinutes -eq 1 ) {
            $TmpTxt = $TmpTxt + $CurMinutes + ' minute'
        }
        else {
            $TmpTxt = $TmpTxt + $CurMinutes + ' minutes'
        }
        $TmpTxt = "System uptime since: $(( get-date $LastBoot ).DateTime ) - $( $TmpTxt )"
        Write-Host "$( Get-TimeStamp ) $ScriptName INFO $( $TmpTxt )"
    }
    #EndRegion 'Show uptime if requested.'

    Return $GetUptime
}
