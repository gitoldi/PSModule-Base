Function Get-Uptime {
    <#
    .SYNOPSIS
        Return the uptime as a time string.

    .DESCRIPTION
        Return the uptime as a time string.
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

    190512 MR
    - 1.0.2.0   Moved from module MarcelRijsbergen to Tools. Version 1 up.
                Modified write-host to write-verbose. Only display data if requested.
                And just return the information to the pipeline. (don't kill the puppies)
    #>
    [ CmdletBinding( )]

    param (
        [ Parameter( )]
        [ Switch ] $Version
    )

    # First get name and return version if requested.
    $ScriptName = '(F)' + [io.path]::GetFileNameWithoutExtension( $MyInvocation.MyCommand.Name )
    [ version ] $ScriptVersion = '1.0.2'
    if ( $Version ) {
        Write-Verbose "$ScriptName version : $ScriptVersion"
        Return $ScriptVersion
    }
    
    # Get system uptime.
    $LastBoot = ( Get-CimInstance Win32_OperatingSystem ).LastBootUpTime
    $GetUptime = ( get-date ) - ( $LastBoot )
    $CurDays = $GetUptime.Days
    $CurHours = $GetUptime.Hours
    $CurMinutes = $GetUptime.Minutes
    # Check days.
    if ( $CurDays -eq 1 ) {
        $TmpTxt = '' + $CurDays + ' day '
    }
    else {
        $TmpTxt = '' + $CurDays + ' days '
    }
    # Check hours.
    if ( $CurHours -eq 1 ) {
        $TmpTxt = $TmpTxt + $CurHours + ' hour '
    }
    else {
        $TmpTxt = $TmpTxt + $CurHours + ' hours '
    }
    # Check minutes.
    if ( $CurMinutes -eq 1 ) {
        $TmpTxt = $TmpTxt + $CurMinutes + ' minute'
    }
    else {
        $TmpTxt = $TmpTxt + $CurMinutes + ' minutes'
    }
    Write-Verbose "System uptime since: $(( get-date $LastBoot ).DateTime ) - $( $TmpTxt )"
    Return $GetUptime
}
