function Get-Calendar { # Get calendar *ix style.
    <#
    .SYNOPSIS
    Implement *ix Cal Command.

    .DESCRIPTION
    Implement *ix Cal Command.

    .EXAMPLE
    PS C:\> Get-Calendar

    This command will show the current month the *ix way.

        november 2019

    ma di wo do vr za zo
                 1  2  3
     4  5  6  7  8  9 10 
    11 12 13 14 15 16 17 
    18 19 20 21 22 23 24 
    25 26 27 28 29 30 

    .EXAMPLE
    PS C:\> Get-Calendar -year 1970 -month 1

    This will show the calendar for the month of the year many computer related things use as 'start' date.

        januari 1970
    
    ma di wo do vr za zo
              1  2  3  4 
     5  6  7  8  9 10 11 
    12 13 14 15 16 17 18 
    19 20 21 22 23 24 25 
    26 27 28 29 30 31 

    .INPUTS
    Inputs (if any)

    .OUTPUTS
    Output (if any)

    .PARAMETER
    Year

    .PARAMETER
    Month

    .PARAMETER
    Next

    .PARAMETER
    Previous

    .NOTES
    General notes
    Sources:
    - https://www.vistax64.com/threads/unix-cal-command.17834/

    #>

    #Region 'Initialization.'
    [ CmdletBinding( )]
    Param(
        [ int16 ] $Year = ( Get-Date ).Year,
        [ int16 ] $Month = ( Get-Date ).Month,
        [ Switch ] $Next,
        [ Switch ] $Previous
    )
    #EndRegion 'Initialization.'

    #Region 'First get name and return version if requested.'
    $ScriptName = '(F)' + [ io.path ]::GetFileNameWithoutExtension( $MyInvocation.MyCommand.Name )
    [ version ] $ScriptVersion = '0.9.0'
    if ( $Version ) {
        Write-Verbose "$ScriptName version : $ScriptVersion"
        Return $ScriptVersion
    }
    #EndRegion 'First get name and return version if requested.'

    #Region 'Setup variables.'
    $script:err = $false
    $Space = " "
    $TmpText = ''
    #EndRegion 'Setup variables.'

    #Region 'Next.'
    if ( $Next ) {
        $Month = (( Get-Date ).Month + 1 )
        if ( $Month -eq 13 ){
            $Year = ( Get-Date ).Year + 1
            $Month = 1
        }
        Write-Verbose "$ScriptName INFO Requested next month: $Month"
    }
    #EndRegion 'Next.'

    #Region 'Previous.'
    if ( $Previous ) {
        $Month = (( Get-Date ).Month - 1 )
        if ( $Month -eq 0 ) {
            $Year = ( Get-Date ).Year - 1
            $Month = 12
        }
        Write-Verbose "$ScriptName INFO Requested previous month: $Month"
    }
    #EndRegion 'Previous.'

    #Region 'Exit on date errors.'
    trap {
        Write-Host -ForegroundColor red "Exception occurred while parsing month/year parameters."
        $script:err = $true
        continue
    }
    #EndRegion 'Exit on date errors.'

    #Region 'Get datetime value of requested year/month and show.'
    $StartDate = new-object System.DateTime $Year, $Month, 1
    if ( $script:err ) {
        return
    }
    $MonthLabel = "$( $StartDate.ToString( 'MMMM' )) $( $StartDate.Year )"
    $AlignCenter = [ Math ]::Ceiling(( 20 - $MonthLabel.Length ) / 2 )
    $TmpText = "`n$( $Space * $AlignCenter )$MonthLabel`n"
    write-host $TmpText
    #EndRegion 'Get datetime value of requested year/month and show.'

    #Region 'Get culture-aware shortnames for day of week and show.'
    $DOWLabel0 = [ System.Globalization.CultureInfo ]::get_CurrentCulture().datetimeformat.shortestdaynames
    Write-Verbose "$ScriptName INFO DowLabel0: $DOWLabel0"
    $i = $first = [ int16 ][ System.Globalization.CultureInfo ]::get_CurrentCulture().datetimeformat.firstdayofweek
    Write-Verbose "$ScriptName INFO First day of week: $first"
    $DowLabel = @()
    1..7 | ForEach-Object {
        $DowLabel += $DowLabel0[ $i ]
        $i = ( $i + 1 ) % 7
    }
    $TmpText = $TmpText + $DowLabel + "`n"
    Write-Host "$DowLabel"
    #EndRegion 'Get culture-aware shortnames for day of week and show.'

    # [culture-aware]
    $NextDate = $StartDate
    $SpaceCount = (([ int16 ] $StartDate.DayOfWeek - $first )) * 3
    if ( $SpaceCount -lt 0 )  {
        $SpaceCount += 21
    }
    # [/culture-aware]

    Write-Host $( $Space * $SpaceCount ) -NoNewline
    $TmpText = $TmpText + ( $Space * $SpaceCount )
    While ( $NextDate.Month -eq $StartDate.Month ) {
        $TmpLine = ''
        $CurDay = "{0,2}" -f $NextDate.Day
        if ( $NextDate.ToString( "MMddyyyy" ) -eq $( Get-Date ).ToString( "MMddyyyy" )) {
            #Write-Host ( "{0,2}" -f $NextDate.Day ) -NoNewline -ForegroundColor yellow
            Write-Host $CurDay -NoNewline -ForegroundColor yellow
        }
        else {
            #Write-Host ( "{0,2}" -f $NextDate.Day ) -NoNewline
            Write-Host $CurDay -NoNewline
        }
        Write-Host " " -NoNewline
        $TmpLine = $TmpLine + $CurDay + ' '
        $NextDate = $NextDate.AddDays( 1 )

        # [culture-aware]
        if ([ int16 ] $NextDate.DayOfWeek -eq $first ) { # [/culture-aware]
            Write-Host
            $TmpLine = $TmpLine + "`n"
        }
        $TmpText = $TmpText + $TmpLine
    }
    write-host "`n"
    [ PSCustomObject ]@{
        Month = $Month
        Year = $Year
        Next = $Next
        Previous = $Previous
        Text = $TmpText
    }
}
