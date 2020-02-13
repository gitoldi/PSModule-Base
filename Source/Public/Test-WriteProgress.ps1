function Test-WriteProgress {
    <#
    .SYNOPSIS
        Short description
    .DESCRIPTION
        Long description
    .EXAMPLE
        PS C:\> <example usage>
        Explanation of what the example does
    .INPUTS
        Inputs (if any)
    .OUTPUTS
        Output (if any)
    .NOTES
        General notes
    #>
    [ CmdletBinding( )]
    param (
        [ Parameter( )]
        [ Int16 ]
        $MaxOuter = 5
        ,
        [ Parameter( )]
        [ Int16 ]
        $MaxInner1 = 5
        ,
        [ Parameter( )]
        [ Int16 ]
        $MaxInner2 = 5
    )

    #Region 'First get name and return version if requested.'
    $ScriptName = [io.path]::GetFileNameWithoutExtension( $MyInvocation.MyCommand.Name ) + '(F)'
    [ version ] $ScriptVersion = '1.0.1'
    Write-Verbose "$( Get-TimeStamp ) $( $ScriptName ) INFO Test if Version was requested: $( $ScriptVersion )"
    if ( $Version ) {
        Write-Verbose "$ScriptName version : $ScriptVersion"
        Return $ScriptVersion
    }
    #EndRegion 'First get name and return version if requested.'

    #Region 'Single progress bar based on a random.'
    ( get-host ).ui.rawui.windowtitle = "MR: MS PowerShell - Test progressbar"
    $defLoop = Get-Random -Minimum 2 -Maximum 25
    write-host "Random step :" $defLoop
    for ( $i = 1; $i -le $defLoop; $i++ ) {
        $tmpprc = $i * ( 100 / $defLoop ) 
        $tmpprc2 = $tmpprc.ToString( "00.00" )

        # write-host "T - $tmpprc - $tmpprc2"
        write-progress -activity "Loop in progress. To 100 in $( $defloop ) steps." -status "$tmpprc2% Complete:" -percentcomplete $tmpprc
        ( get-host ).ui.rawui.windowtitle = "MR: MS PowerShell - Test progressbar - " + $tmpprc2 + "%."
        start-sleep 1
    }
    #EndRegion 'Single progress bar based on a random.'

    #Region 'Multilevel progress bar.'
    ( get-host ).ui.rawui.windowtitle = "MR: MS PowerShell - Test progressbar - Done."
    Read-Host "ENTER om door te gaan."
    for ( $I = 1; $I -le $MaxOuter; $I++ ) {
        Write-Progress -Activity Updating -Status "Progress-> $( $I ) of $( $MaxOuter )" -PercentComplete (( $I / $MaxOuter ) * 100 ) -CurrentOperation OuterLoop
        for ( $j = 1; $j -le $MaxInner1; $j++ ) {
            Write-Progress -Id 1 -Activity Updating -Status "Progress: $( $j ) of $( $MaxInner1 )" -PercentComplete (( $j /$MaxInner1 ) * 100 ) -CurrentOperation 'Loop Level 1 - 1'
        }
        for ( $k = 1; $k -le $MaxInner2; $k++ ) {
            Write-Progress -Id 2 -Activity Updating -Status "Progress: $( $k ) of $( $MaxInner2 )" -PercentComplete (( $k / $MaxInner2 ) * 100 ) -CurrentOperation 'Loop Level 1 - 2'
            for ( $l = 1; $l -le $MaxInner2; $l++ ) {
                Write-Progress -Id 3 -Activity Updating -Status "Progress: $( $l ) of $( $MaxInner2 )" -PercentComplete (( $l / $MaxInner2 ) * 100 ) -CurrentOperation 'Loop Level 2 - 1'
            }
            for ( $m = 1; $m -le $MaxInner2; $m++ ) {
                Write-Progress -Id 4 -Activity Updating -Status "Progress: $( $m ) of $( $MaxInner2 )" -PercentComplete (( $m / $MaxInner2 ) * 100 ) -CurrentOperation 'Loop Level 2 - 2'
                Start-Sleep -Seconds 1
            }
            Start-Sleep -Seconds 1
        }
    }
    #EndRegion 'Multilevel progress bar.'
}
