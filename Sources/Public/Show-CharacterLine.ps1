# Function Start : Show-CharacterLine
function Show-CharacterLine {
    <#
    .SYNOPSIS
    Show a line with numbers to see how wide your command line is.
    
    .DESCRIPTION
    Show a line with numbers to see how wide your command line is.
    First setup uses a fixed 132 character line.

    .EXAMPLE
    PS C:\> <example usage>
    Explanation of what the example does

    .INPUTS
    Inputs (if any)

    .OUTPUTS
    Output (if any)

    .NOTES
    Author      : Marcel Rijsbergen
    Copyright   : 2018 - <today>, Marcel Rijsbergen.
    ToDo        :
    - Setup a parameter to define the number of characters to put on a line to display.
    
    History     :

    1.0.3 MR
    - Instead of a loop with 10 at a time make it per number.
    - Now 128, 160, 192 is possible too.
    - Use Stringbuilder to create a total string that will be returned.

    1.0.2 MR Moved to module Tools.

    1.0.1 MR It is a function in module MarcelRijsbergen.

    1.0.0 MR Unknown.
    #>
    [ CmdletBinding( )]

    param (
        # Parameter for Version.
        [ Parameter( )]
        [ Switch ] $Version
        ,
        # Parameter for maximum loop.
        [ Parameter( HelpMessage = "Maximum for loop. Default is 80 numbers." )]
        [ int16 ] $MaxLoop = 80
        ,
        # Parameter for display each 10th.
        [ Parameter( )]
        [ switch ] $Each10 = $false
    )

    # First get name and return version if requested.
    $ScriptName = [io.path]::GetFileNameWithoutExtension( $MyInvocation.MyCommand.Name )
    [ version ] $ScriptVersion = '1.0.3'
    if ( $Version ) {
        Write-Verbose "$ScriptName version : $ScriptVersion"
        Return $ScriptVersion
    }

    $StringBuilder = New-Object System.Text.StringBuilder
    Write-Host ( Get-TimeStamp ) $ScriptName 'INFO Current terminal width :' $Host.UI.RawUI.WindowSize.Width
    Write-Host ( Get-TimeStamp ) $ScriptName 'INFO Current terminal height:' $Host.UI.RawUI.WindowSize.Height

    if ( $Each10 ) {
        Write-Verbose "$( Get-TimeStamp ) $( $ScriptName ) INFO Show each 10th character."
        for ( $i = 1; $i -le ( $MaxLoop / 10 ); $i++ ) {
            if ( $i -lt 10 ) {
                Write-Host "         $( $i )" -NoNewline
            }
            elseif ( $i -ge 100 ) {
                Write-Host "       $( $i )" -NoNewline
            }
            else {
                Write-Host "        $( $i )" -NoNewline
            }
        }
        Write-Host ''
    }

    [ int16 ] $TmpNum = 1
    Write-Verbose "$( Get-TimeStamp ) $( $ScriptName ) INFO Display an incrementing number until MaxLoop ($( $MaxLoop )) is reached."
    for ( $i = 1; $i -le $MaxLoop; $i++ ) {
        if ( $TmpNum -eq 10 ) {
            Write-Host '0' -NoNewline -ForegroundColor Cyan
            $null = $StringBuilder.Append( '0' )
            $TmpNum = 1
        }
        else {
            Write-Host $TmpNum -NoNewline
            $null = $StringBuilder.Append( $TmpNum )
            $TmpNum++
        }
    }
    Write-Host ''
    Return $StringBuilder.ToString()
}
# Function End : Show-CharacterLine
