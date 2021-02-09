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
    Author  : Marcel Rijsbergen (MR)
    History :

    210209 V1.1.0
    - Added 'Version'.
    - Replaced 'Write-Host' to 'Write-Output'.

    2020mmdd Vx.y.z MR
    - Created
    #>
    [CmdletBinding()]
    param (
        [Parameter()]
        [Int16]
        $MaxOuter = 5
        ,
        [Parameter()]
        [Int16]
        $MaxInner1 = 5
        ,
        [Parameter()]
        [Int16]
        $MaxInner2 = 5
        ,
        [Parameter(ParameterSetName='Version')]
        [Switch] $Version
    )

    #Region 'First get name and return version if requested.'
    $ScriptName = [io.path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)
    [version] $ScriptVersion = '1.1.0'
    Write-Verbose -Message "$(Get-TimeStamp) $($ScriptName) INFO Test if Version was requested: $($ScriptVersion)"
    if ($Version) {
        Write-Verbose "$ScriptName version : $ScriptVersion"
        Return $ScriptVersion
    }
    #EndRegion 'First get name and return version if requested.'

    #Region 'Single progress bar based on a random.'
    (Get-Host).ui.rawui.windowtitle = "MR: MS PowerShell - Test progressbar"
    $defLoop = Get-Random -Minimum 2 -Maximum 25
    write-host "Random step :" $defLoop
    for ($i = 1; $i -le $defLoop; $i++) {
        $tmpprc = $i * (100 / $defLoop) 
        $tmpprc2 = $tmpprc.ToString("00.00")

        # write-host "T - $tmpprc - $tmpprc2"
        write-progress -activity "Loop in progress with random steps. To 100 in $($defloop) steps." -status "$tmpprc2% Complete:" -percentcomplete $tmpprc
        (Get-Host).ui.rawui.windowtitle = "MR: MS PowerShell - Test progressbar - " + $tmpprc2 + "%."
        start-sleep -Seconds 1
    }
    #EndRegion 'Single progress bar based on a random.'

    #Region 'Multilevel progress bar.'
    (Get-Host).ui.rawui.windowtitle = "MR: MS PowerShell - Test progressbar - Done."
    Read-Host "ENTER om door te gaan."
    for ($I = 1; $I -le $MaxOuter; $I++) {
        Write-Progress -Activity Updating -Status "Progress-> $($I) of $($MaxOuter)" -PercentComplete (($I / $MaxOuter) * 100) -CurrentOperation OuterLoop
        for ($j = 1; $j -le $MaxInner1; $j++) {
            Write-Progress -Id 1 -Activity Updating -Status "Progress: $($j) of $($MaxInner1)" -PercentComplete (($j /$MaxInner1) * 100) -CurrentOperation 'Loop Level 1 - loop 1'
            Start-Sleep -Milliseconds 250
        }
        for ($k = 1; $k -le $MaxInner2; $k++) {
            Write-Progress -Id 2 -Activity Updating -Status "Progress: $($k) of $($MaxInner2)" -PercentComplete (($k / $MaxInner2) * 100) -CurrentOperation 'Loop Level 1 - loop 2'
            for ($l = 1; $l -le $MaxInner2; $l++) {
                Write-Progress -Id 3 -Activity Updating -Status "Progress: $($l) of $($MaxInner2)" -PercentComplete (($l / $MaxInner2) * 100) -CurrentOperation 'Loop Level 2 - loop 1'
                Start-Sleep -Milliseconds 250
            }
            for ($m = 1; $m -le $MaxInner2; $m++) {
                Write-Progress -Id 4 -Activity Updating -Status "Progress: $( $m ) of $($MaxInner2)" -PercentComplete (($m / $MaxInner2) * 100) -CurrentOperation 'Loop Level 2 - loop 2'
                Start-Sleep -Seconds 1
            }
            Start-Sleep -Seconds 1
        }
    }
    #EndRegion 'Multilevel progress bar.'
}
