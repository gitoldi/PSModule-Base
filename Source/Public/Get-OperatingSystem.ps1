function Get-OperatingSystem {
    <#
    .SYNOPSIS
    Get Operating System information.

    .DESCRIPTION
    Get Operating System information.

    There are some places to look for information.
    But 1 thing i couldn't find is the 'YYMM' release info in default PowerShell commands/outputs.
    Found all information i need (for now) in:
        HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\
    
    If i learn about more interesting information it's pretty easy to add it this to the function.

    Other sources:
    - https://en.wikipedia.org/wiki/Windows_10_version_history
    - https://www.howtogeek.com/236195/how-to-find-out-which-build-and-version-of-windows-10-you-have/
        - the next 2 bullets show the 'YYMM', but are not PowerShell examples.
        - Windows + I -> Settings. Navigate to System > About.
        - Windows + R -> type 'winver'.
    - https://www.howtogeek.com/58298/stupid-geek-tricks-how-to-display-the-windows-version-on-the-desktop/
        - Show some info permanently on desktop.
        - HKEY_CURRENT_USER\Control Panel\Desktop, set 'PaintDesktopVersion' to 1.
    - Windows + R -> type 'systeminfo'.

    .PARAMETER Version
    Show the current version of this script end exits.

    .EXAMPLE
    PS > Get-OperatingSystem

    ProductName    : Windows 10 Home
    ReleaseId      : 1903
    CurrentBuild   : 18362
    CurrentType    : Multiprocessor Free
    CurrentVersion : 6.3
    EditionID      : Core
    PSEdition      : Desktop
    Architecture   : AMD64
    AllProperties  : @{SystemRoot=C:\WINDOWS; ... }

    .EXAMPLE
    PS > Get-OperatingSystem -Version

    Major  Minor  Build  Revision
    -----  -----  -----  --------
    0      0      1      -1

    .EXAMPLE
    PS > Get-OperatingSystem -Verbose
    VERBOSE: 20200221-173239.739 (F)Get-OperatingSystem INFO Begin.
    VERBOSE: 20200221-173239.740 (F)Get-OperatingSystem INFO Setup variables.
    VERBOSE: 20200221-173239.741 (F)Get-OperatingSystem INFO Get data.
    VERBOSE: 20200221-173239.744 (F)Get-OperatingSystem INFO ...For property: CurrentBuild
    VERBOSE: 20200221-173239.746 (F)Get-OperatingSystem INFO ...For property: CurrentType
    VERBOSE: 20200221-173239.747 (F)Get-OperatingSystem INFO ...For property: CurrentVersion
    VERBOSE: 20200221-173239.760 (F)Get-OperatingSystem INFO ...For property: EditionID
    VERBOSE: 20200221-173239.762 (F)Get-OperatingSystem INFO ...For property: ProductName
    VERBOSE: 20200221-173239.763 (F)Get-OperatingSystem INFO ...For property: ReleaseId
    VERBOSE: 20200221-173239.765 (F)Get-OperatingSystem INFO End, return PSCustomObject.

    ProductName    : Windows 10 Home
    ReleaseId      : 1903
    CurrentBuild   : 18362
    CurrentType    : Multiprocessor Free
    CurrentVersion : 6.3
    EditionID      : Core
    PSEdition      : Desktop
    Architecture   : AMD64
    AllProperties  : @{SystemRoot=C:\WINDOWS; ... }

    .EXAMPLE
    PS > $xx = Get-OperatingSystem
    
    PS > $xx.ReleaseId
    1903

    PS > $xx.AllProperties.BuildLab
    18362.19h1_release.190318-1202

    .INPUTS
    NA

    .OUTPUTS
    PSCustomObject

    .NOTES
    Author      : Marcel Rijsbergen
    History:

    200221 MR
    - 1.0.0 Created, tested and released.

    #>

    #Region 'Initialization.'
    [ CmdletBinding( )]

    param (
        [ Parameter( )]
        [ Switch ] $Version
    )

    # First get name and return version if requested.
    $ScriptName = '(F)' + [io.path]::GetFileNameWithoutExtension( $MyInvocation.MyCommand.Name )
    [ version ] $ScriptVersion = '1.0.0'
    Write-Verbose "$( Get-TimeStamp ) $ScriptName INFO Begin."
    if ( $Version ) {
        Write-Verbose "$( Get-TimeStamp ) $ScriptName INFO Version : $ScriptVersion"
        Return $ScriptVersion
    }
    #EndRegion 'Initialization.'

    #Region 'Variables.'
    Write-Verbose "$( Get-TimeStamp ) $ScriptName INFO Setup variables."
    $ThisRegistry = 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\'
    $ThisProperties = @(
        'CurrentBuild',
        'CurrentType',
        'CurrentVersion',
        'EditionID',
        'ProductName',
        'ReleaseId'
    )
    #EndRegion 'Variables.'

    #Region 'Get data.'
    Write-Verbose "$( Get-TimeStamp ) $ScriptName INFO Get data."
    $AllProperties = Get-ItemProperty "registry::$( $ThisRegistry )"
    foreach ( $TmpProperty in $ThisProperties ) {
        Write-Verbose "$( Get-TimeStamp ) $ScriptName INFO ...For property: $( $TmpProperty )"
        $TmpValue = $AllProperties.$TmpProperty
        Set-Variable -Name "Var$( $TmpProperty )" -Value $TmpValue
    }
    #EndRegion 'Get data.'

    Write-Verbose "$( Get-TimeStamp ) $ScriptName INFO End, return PSCustomObject."
    [ PSCustomObject ] @{
        ProductName = $VarProductName
        ReleaseId = $VarReleaseID
        CurrentBuild = $VarCurrentBuild
        CurrentType = $VarCurrentType
        CurrentVersion = $VarCurrentVersion
        EditionID = $VarEditionID
        Architecture = $env:PROCESSOR_ARCHITECTURE
        AllProperties = $AllProperties
    }
}
