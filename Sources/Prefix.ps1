<#
.SYNOPSIS
Prefix part to a module.

.DESCRIPTION
Prefix part to a module.
Based on ModuleBuilder documentation.
Use this prefix part to do some initialization for the module.
Like : load config for this module.

.EXAMPLE
NA

.INPUTS
NA

.OUTPUTS
NA

.NOTES
Copyright 2018-<today>, Marcel Rijsbergen.
    
History:
Do not forget to create a short modification text in CHANGELOG.md.

190518 MR
- 1.0.3 Added VerbosePreference check.

190518 MR
- 1.0.2 Still struggling with -verbose.

#>

#Region 'Initialize.'
[ CmdletBinding( )]

param( )

$CurCommand = $MyInvocation.MyCommand
$ScriptName = [ io.path ]::GetFileNameWithoutExtension( $CurCommand.Name )
$ScriptFolder = Split-Path $CurCommand.Path
[ bool ] $CurDebug = $false
[ bool ] $IsVerbose = $false

#Region : 'Check if Verbose file is set.'
$VerboseFile = $ScriptFolder + '\' + $ScriptName + '.On'
if ( Test-Path $VerboseFile ){
    $CurDebug = $true
}
#EndRegion : 'Check if Verbose file is set.'

#Region 'Function - Required - Get-TimeStamp.'
if ( Get-Command Get-TimeStamp -ErrorAction SilentlyContinue ) {
    if ( $CurDebug ) {
        Write-Host "$( Get-TimeStamp ) $( $ScriptName ) INFO Function 'Get-TimeStamp' exists."
    }
} else {
    if ( $CurDebug ) {
        Write-Host '...' $ScriptName "INFO Function 'Get-TimeStamp' does not exist, create a quick one."
    }
    function Get-TimeStamp {
        <#

        .SYNOPSIS
        Return a time stamp to be used in e.g.: logfiles, 

        .DESCRIPTION
        Return a time stamp to be used in e.g.: logfiles, 

        .EXAMPLE
        PS> Get-TimeStamp
        20191004-184821.729

        .INPUTS
        NA

        .OUTPUTS
        NA

        .NOTES
        Author      : Marcel Rijsbergen.
        Copyright   : 2018-<today>, Marcel Rijsbergen.
        History     : Can not remember. Used it already pretty quick after i created functions.
        Ideas       :
        - Add parameters to be able to return different output.
        
        #>
        Return ( Get-Date -Format "yyyyMMdd" )        
    }
}
#EndRegion 'Function - Required - Get-TimeStamp.'

if ( $CurDebug ) { Write-Host "$( Get-TimeStamp ) $( $ScriptName ) INFO Loading module." }
#EndRegion 'Initialize.'

#Region 'Test for config and read it.'
$Curdir = Get-Location
if ( $CurDebug ) { Write-Host "$( Get-TimeStamp) $ScriptName INFO Current folder : $( $curdir )" }
$ConfigFile = $ScriptFolder + '\' + $ScriptName + '-Config.psd1'
$ConfigName = $ScriptName -replace '[-_]',''
if ( $CurDebug ) { Write-Host "$( Get-TimeStamp) $ScriptName INFO Try Config file : $( $ConfigFile )" }
if ( $CurDebug ) { Write-Host "$( Get-TimeStamp) $ScriptName INFO Set Config variable : $( $ConfigName )" }
if ( Test-Path $ConfigFile ) {
    try {
        $setvarhash = @{
            Name = "Config.$( $ConfigName )"
            Value = ( Import-PowerShellDataFile -Path $ConfigFile )
            Description = "Configuration for module $( $ScriptName )"
        }
        Set-Variable -Scope Global @setvarhash
        if ( $CurDebug ) {
            Write-Host "$( Get-TimeStamp) $ScriptName INFO Config loaded into : $( Get-Variable $ConfigFile )" -ForegroundColor Green
        }
    } catch {
        if ( $CurDebug ) {
            Write-Host "$( Get-TimeStamp) $ScriptName WARNING Config load : Failed" -ForegroundColor Yellow
        }
    }
} else {
    if ( $CurDebug ) {
        Write-Host "$( Get-TimeStamp) $ScriptName INFO No config file :" $ConfigFile
    }
}
#EndRegion 'Test for config and read it.'
