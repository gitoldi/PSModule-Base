function Get-DotnetFramework {
    <#

    .SYNOPSIS
    Show .NET framework versions.

    .DESCRIPTION
    Show .NET framework versions.

    .LINK
    https://www.syspanda.com/index.php/2018/09/25/check-installed-net-versions-using-powershell/

    .NOTES
    Copyright   : Centric Netherlands B.V.
    Organization: IT Outsourcing - System Management Center (SMC)
    Author      : Marcel Rijsbergen.
    History     :

    200316 MR
    - 1.0.1 Copied original from SAM domain into this module.

    .EXAMPLE
    PS1>

    #>

    #Region 'Initialize.'

    #Requires -Version 4

    [ CmdletBinding( )]

    param(
        [ Parameter( )]
        [ Switch ] $Version
        ,
        [ Parameter( )]
        [ array ] $Servers = $env:COMPUTERNAME
    )

    # First get name and return version if requested.
    $ScriptName = '(F)' + [io.path]::GetFileNameWithoutExtension( $MyInvocation.MyCommand.Name )
    [ version ] $ScriptVersion = '1.0.1'
    if ( $Version ) {
        Write-Verbose -Message "$( Get-TimeStamp ) $( $ScriptName ) INFO Version : $ScriptVersion"
        Return $ScriptVersion
    }

    Write-Verbose -Message "$( Get-TimeStamp ) $( $ScriptName ) INFO Begin."
    #EndRegion 'Initialize.'

    #Region 'Set variables.'
    $RegKey = 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\'
    #EndRegion 'Set variables.'
    
    #Region 'Main script.'

    #EndRegion 'Main script.'
    Write-Host "$( Get-TimeStamp ) $( $ScriptName ) INFO Test servers # $( $Servers.Count )"
    Write-Verbose -Message "$( Get-TimeStamp ) $( $ScriptName ) INFO Test registry key : $( $Regkey )"
    foreach ( $Server in $Servers ) {
        Write-Output "$( Get-TimeStamp ) $( $ScriptName ) INFO Start for node : $( $Server )"
        if ( $Server -eq $env:COMPUTERNAME ) {
            Write-Verbose -Message "$( Get-TimeStamp ) $( $ScriptName ) INFO Local node."
            Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\*' -Recurse | 
                Get-ItemProperty -Name Version, Release -ErrorAction 0 | 
                Where-Object { $_.PSChildName -match '^(?!S)\p{L}' } | 
                Select-Object PSChildName, Version, Release # | Select-Object -ExpandProperty Version | Sort-Object Version
            #Write-Output "`n";
        }
        else {
            Write-Verbose -Message "$( Get-TimeStamp ) $( $ScriptName ) INFO Remote node."
            try {
                Invoke-Command -ComputerName $Server -Scriptblock {
                    Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\*' -Recurse | 
                        Get-ItemProperty -Name Version,Release -ErrorAction 0 | 
                        Where-Object { $_.PSChildName -match '^(?!S)\p{L}' } | 
                        Select-Object PSChildName, Version, Release # | Select-Object -ExpandProperty Version | Sort-Object Version
                    #Write-Output "`n"; 
                }
            }
            catch {
                Write-Output "$( Get-TimeStamp ) $( $ScriptName ) WARNING Remote node error."
            }
        }
        Write-Output '----------'
    }
    Write-Verbose "$( Get-TimeStamp ) $ScriptName INFO End."
}
