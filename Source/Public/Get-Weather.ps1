# Function Start: Get-Weather
Function Get-Weather {
    <#
    .SYNOPSIS
    Get Weather of a City

    .DESCRIPTION
    Fetches Weather report of a City from website - http://wttr.in/ courtsey Igor Chubin [Twitter- @igor_chubin]

    .PARAMETER City
    Name of City

    .PARAMETER Tomorrow
    Switch to include tomorrow's Weather report

    .PARAMETER DayAfterTomorrow
    Switch to include Day after tomorrow's Weather report

    .EXAMPLE
    Get-Weather  "Los Angles" -Tomorrow -DayAfterTomorrow

    .EXAMPLE
    'london', 'delhi', 'beijing' | Get-Weather

    .EXAMPLE
    Sources:
    - https://geekeefy.wordpress.com/2017/08/24/get-weather-report-using-powershell/
    - https://www.makeuseof.com/tag/get-curly-10-useful-things-can-curl/
    - wttr.in - https://github.com/chubin/wttr.in
    - wego - https://github.com/schachmat/wego

    .NOTES
    Blog - RidiCurious.com
    History:

    200303 MR.
    - 1.0.3 Moved from MarcelRijsbergen.Tools to PSModule-Personal.
    
    190605 MR.
    - 1.0.2 Modified version to 3 deep.

    190507 MR.
    - 1.0.0.2-6 Errors, removed 'process' block.
    - 1.0.1.0   Works, a new build as working.
        
    190502 MR. 
    - 1.0.0.1   Added the switch Version.

    ToDo:
    - Create a Pester test.
    #>

    #[ Alias( 'Wttr' )]
    [ Cmdletbinding( )]
    Param(
            [ Parameter(
                ParameterSetName = 'Weather',
                Mandatory = $true,
                HelpMessage = 'Enter name of the City to get weather report',
                ValueFromPipeline = $true,
                Position = 0
            )]
            [ ValidateNotNullOrEmpty( )]
            [ array ] $City,

            [ Parameter( ParameterSetName = 'Weather' )]
            [ switch ] $Tomorrow,

            [ Parameter( ParameterSetName = 'Weather' )]
            [ switch ] $DayAfterTomorrow,

            [ Parameter( ParameterSetName = 'Version' )]
            [ switch ] $Version
    )

    $ScriptName = [ io.path ]::GetFileNameWithoutExtension( $MyInvocation.MyCommand.Name )
    [ version ] $ScriptVersion = '1.0.2'
    if ( $Version ) {
        Write-Verbose "$ScriptName version : $ScriptVersion"
        Return $ScriptVersion
    }
    
    Foreach( $Item in $City ) {
        try {
            # Check Operating System Version
            If (( Get-WmiObject win32_operatingsystem ).caption -like "*Windows 10*" ) {
                $Weather = $( Invoke-WebRequest "http://wttr.in/$City" -UserAgent curl ).content -split "`n"
            }
            else {
                $Weather = ( Invoke-WebRequest "http://wttr.in/$City" ).ParsedHtml.body.outerText  -split "`n"
            }

            If ( $Weather ) {
                $Weather[ 0..16 ]
                If ( $Tomorrow ) { $Weather[ 17..26 ] }
                If ( $DayAfterTomorrow ) { $Weather[ 27..36 ] }
            }
        }
        catch {
            $_.exception.Message
        }
    }
}
# Function End: Get-Weather
