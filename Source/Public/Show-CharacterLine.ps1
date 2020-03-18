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

    1.0.5 MR
    - Added alphabet lower, upper and numbers.

    1.0.4 MR
    - Copied the 132 line example from the 'MarcelRijsbergen.Tools\Show-CharacterLine'.

    1.0.3 MR
    - Instead of a loop with 10 at a time make it per number.
    - Now 128, 160, 192 is possible too.
    - Use Stringbuilder to create a total string that will be returned.

    1.0.2 MR Moved to module Tools.

    1.0.1 MR It is a function in module MarcelRijsbergen.

    1.0.0 MR Unknown.
    #>

    #Region 'Initialization.'

    [ CmdletBinding( )]

    param (
        # Parameter for Version.
        [ Parameter( )]
        [ Switch ] $Version
        ,
        # Parameter for maximum loop.
        [ Parameter( HelpMessage = "Maximum for character loop. Default is 80." )]
        [ int16 ] $MaxLoop = 80
        ,
        # Parameter for display a line with 132 characters.
        [ Parameter( )]
        [ switch ] $Line132 = $false
        ,
        # Parameter for creating an lowercase alphabet array and return it in PSCustomObject.
        [ Parameter( )]
        [ switch ] $AlphabetLower = $false
        ,
        # Parameter for creating an uppercase alphabet array and return it in PSCustomObject.
        [ Parameter( )]
        [ switch ] $AlphabetUpper = $false
        ,
        # Parameter for creating a numbers array and return it in PSCustomObject.
        [ Parameter( )]
        [ switch ] $Numbers = $false
    )

    # First get name and return version if requested.
    $ScriptName = [io.path]::GetFileNameWithoutExtension( $MyInvocation.MyCommand.Name )
    [ version ] $ScriptVersion = '1.0.5'
    if ( $Version ) {
        Write-Verbose "$( Get-TimeStamp ) $( $ScriptName ) INFO Version : $ScriptVersion"
        Return $ScriptVersion
    }
    #EndRegion 'Initialization.'

    #Region 'Set variables.'
    # Set Variables.
    $ArrLower   = @( )
    $ArrUpper   = @( )
    $ArrNumbers = @( )
    $StringBuilder = New-Object System.Text.StringBuilder
    #EndRegion 'Set variables.'

    #Region 'Display current screen and window sizes.'
    Write-Host ( Get-TimeStamp ) $ScriptName 'INFO Current screen width :' $Host.UI.RawUI.MaxPhysicalWindowSize.Width
    Write-Host ( Get-TimeStamp ) $ScriptName 'INFO Current screen width :' $Host.UI.RawUI.MaxPhysicalWindowSize.Height
    Write-Host ( Get-TimeStamp ) $ScriptName 'INFO Current terminal width :' $Host.UI.RawUI.WindowSize.Width
    Write-Host ( Get-TimeStamp ) $ScriptName 'INFO Current terminal height:' $Host.UI.RawUI.WindowSize.Height
    #EndRegion 'Display current screen and window sizes.'

    #Region 'Display each 10th character.'
    Write-Verbose "$( Get-TimeStamp ) $( $ScriptName ) INFO Option : Maxloop OR Line132"
    if ( $MaxLoop -or $Line132 ) {
        if ( $Line132 ) {
            $MaxLoop = 132
        }
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
    #EndRegion 'Display each 10th character.'

    #Region 'Display character line based on 'MaxLoop'.'
    Write-Verbose "$( Get-TimeStamp ) $( $ScriptName ) INFO Display an incrementing number until MaxLoop ($( $MaxLoop )) is reached."
    [ int16 ] $TmpNum = 1
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
    #EndRegion 'Display character line based on 'MaxLoop'.'

    #Region 'Create array of lowercase characters.'
    Write-Verbose "$( Get-TimeStamp ) $( $ScriptName ) INFO Option : Alphabet lowercase"
    $ArrLower = [ char[ ]] ([ int ][ char ] 'a' .. [ int ][ char ] 'z' )
    if ( $AlphabetLower ) {
        $ArrLower
    }
    #EndRegion 'Create array of lowercase characters.'

    #Region 'Create array of uppercase characters.'
    Write-Verbose "$( Get-TimeStamp ) $( $ScriptName ) INFO Option : Alphabet uppercase"
    $ArrUpper = [ char[ ]] ([ int ][ char ] 'A' .. [ int ][ char ] 'Z' )
    if ( $AlphabetUpper ) {
        $ArrUpper
    }
    #EndRegion 'Create array of uppercase characters.'

    #Region 'Create array of numbers.'
    Write-Verbose "$( Get-TimeStamp ) $( $ScriptName ) INFO Option : Numbers"
    $ArrNumbers = ([ int ] 0 .. [ int ] 9 )
    if ( $Numbers ) {
        $ArrNumbers
    }
    #EndRegion 'Create array of numbers.'

    #Region 'Create PSCustomObject.'
    Write-Verbose "$( Get-TimeStamp ) $( $ScriptName ) INFO Create PSCustomObject."
    [ PSCustomObject ] @{
        AlphabetLower   = $ArrLower
        AlphabetUpper   = $ArrUpper
        Numbers         = $ArrNumbers
        String          = $StringBuilder.ToString()
    }
    #EndRegion 'Create PSCustomObject.'
}
# Function End : Show-CharacterLine
