<#
.SYNOPSIS
Prefix part to a module.

.DESCRIPTION
Prefix part to a module.
Based on ModuleBuilder documentation.
Use this prefix part to do some initialization for the module.
Like : load config for this module to the $Global environment.

.EXAMPLE
NA

.INPUTS
NA

.OUTPUTS
NA

.NOTES
Copyright 2019-<today>, Marcel Rijsbergen.
    
History:
Do not forget to create a short modification text in CHANGELOG.md.

190518 MR
- 1.0.3 Added VerbosePreference check.

190518 MR
- 1.0.2 Still struggling with -verbose.

#>
[ CmdletBinding( )]

param( )

#Region 'Initialize.'
$ScriptName = [ io.path ]::GetFileNameWithoutExtension( $MyInvocation.MyCommand.Name )

# Check if Verbose is supplied.
if ( $MyInvocation.BoundParameters[ "Verbose" ].IsPresent ) {
    if ( $VerbosePreference -ne 'SilentlyContinue' ) {
        $TmpText = $VerbosePreference
        $IsVerbose = $true
    }
    else {
        $TmpText = 'SilentlyContinue'
        $IsVerbose = $false
    }
}
else {
    $TmpText = 'No verbose supplied.'
    $IsVerbose = $false
}
#EndRegion 'Initialize.'

#Region 'Function - Required.'
if ( Get-Command Get-TimeStamp -ErrorAction SilentlyContinue ) {
    Write-Verbose "$( Get-TimeStamp ) $( $ScriptName ) INFO Function 'Get-TimeStamp' exists."
} else {
    Write-Host '...' $ScriptName "INFO Function 'Get-TimeStamp' does not exist, create a quick one."
    function Get-TimeStamp {
        Return ( Get-Date -Format "yyyyMMdd" )        
    }
}
#EndRegion 'Function - Required.'

Write-Verbose "$( Get-TimeStamp ) $( $ScriptName ) INFO Loading module."
Write-Verbose "$( Get-TimeStamp ) $( $ScriptName ) INFO Verbose status : $( $TmpText )"

# Test for config.
if ( $CurConfig ) {
    $ConfigFile = $CurConfig + 'Config-' + $ScriptName + '.psd1'
    Write-Verbose "$( Get-TimeStamp) $ScriptName INFO Try Config file : $( $ConfigFile )"
    if ( Test-Path $ConfigFile ) {
        try {
            #$Config.$BaseName = ( Import-PowerShellDataFile -Path $ConfigFile.FullName )
            Set-Variable -Scope Global -Name "Config$( $ScriptName )" -Value ( Import-PowerShellDataFile -Path $ConfigFile ) -Description "Configuration for module $( $ScriptName )"
            Write-Host "$( Get-TimeStamp) $ScriptName INFO Config loaded : $( $ConfigFile )" -ForegroundColor Green
        }
        catch {
            Write-Host "$( Get-TimeStamp) $ScriptName WARNING Config load : Failed" -ForegroundColor Yellow
        }
    }
    else {
        Write-Host "$( Get-TimeStamp) $ScriptName INFO No config file :" $ConfigFile
    }
}
else {
    Write-Host "$( Get-TimeStamp) $ScriptName INFO No config folder found."
}
# End - Prefix to module.
