function Get-TimeStamp() {
    <#
    .SYNOPSIS
    Create a timestamp.

    .DESCRIPTION
    Many times a timestamp is needed for logging or other output reasons.
    This function creates a fixed one in the form: YYYYMMDD-HHMMSS.mmm
    YYYY    Year
    MM      Month number as 2 digits.
    DD      Day number as 2 digits.
    HH      Hour as 2 digits.
    MM      Minute as 2 digits.
    SS      Second as 2 digits.
    mmm     Miliseconds as 3 digits.

    .EXAMPLE
    PS C:\> Get-TimeStamp
    20180413-$LenMax3116.577

    .NOTES
    Author      : Marcel Rijsbergen.
    Maybe in the future add some parameter(s) to be able to return a different string.

    #>

    #Region 'Initialization'
    [ CmdletBinding( )]

    param (
        [ Parameter( )]
        [ Switch ] $Version
    )

    # First get name and return version if requested.
    # Get current (sub)routine name.
    #
    $FunctionName = '(F)' + $MyInvocation.MyCommand
    [ version ] $ScriptVersion = '1.0.1'
    if ( $Version ) {
        Write-Verbose "$FunctionName version : $ScriptVersion"
        Return $ScriptVersion
    }
    #write-verbose "Function Begin : $FunctionName"
    #EndRegion 'Initialization'

    #Region 'Setup string.'
    $CurDate = Get-Date
    $CurStamp = Get-Date -UFormat "%Y%m%d-%H%M%S"

    # Get current millisecond and add prefix 0 if less than 10.
    $CurMilliSec = $CurDate.Millisecond
    if ( $CurMilliSec -lt 10 ) {
        $CurMilliSec = "0$( $CurMilliSec )"
    }
    if ( $CurMilliSec -lt 100 ) {
        $CurMilliSec = "0$( $CurMilliSec )"
    }

    # Create time stamp string for logging.
    $GetCurStamp = $CurStamp + ".$( $CurMilliSec )"

    # Depending on debug level show info.
    #write-verbose "$FunctionName - $GetCurStamp"
    #EndRegion 'Setup string.'

    # Function is finished, return data to caller.
    #write-verbose "Function End: $FunctionName"
    return [ string ]$GetCurStamp
}
