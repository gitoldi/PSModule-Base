@{
    <#
    File        : PSModule-Personal-Config.psd1
    Purpose     : Settings for my personal GitHub PowerShell Module.
    Version     : 1.0
    Source      : 
        - https://docs.microsoft.com/en-us/powershell/dsc/configurations/configdata
        - DSC descriptions, but they mostly use different type (XML).
    Usage       :
    PS> $xx = Import-PowerShellDataFile -Path .\Folder\Config-File.psd1
    PS> $xx
    Name                           Value
    ----                           -----
    Software                       {System.Collections.Hashtable, System.Collections.Hashtable, System.Collections.Hashtable, System.Collections.Hashtable...}
    Folders                        {Config, Logs, Html, Output...}

    PS> $xx.Software.Where({ $_.function -match 'snow' })

    Created     : 191003
    History     :
    - 191003 MR. Config file for PowerShell.

    #>

    Folders = @(
        # These folders will be checked for existing in $env:userprofile'\documents'.
        'Config',   # Will contain configuration files like this '.psd1' file.
        'Logs',     # Will contain logfiles.
        'Html',     # Will contain HTML files.
        'Output',   # Will contain all sorts of output like: csv, xml, pdf
        'Temp'      # Can be used for temporary files.
    )

    Software = @(
        @{
            Function = '*'
            Registry = ''
            Keys = 'CurrentVersion', 'Install Directory'
        },
        @{
            Function = 'Snow Inventory - SI'
            Registry = 'HKEY_LOCAL_MACHINE\SOFTWARE\mozilla.org\Mozilla'
            Keys = 'CurrentVersion'
        },
        @{
            Function = 'Snow Inventory Service Gateway - SI-SG'
            Registry = 'HKEY_LOCAL_MACHINE\SOFTWARE\Mozilla\Mozilla Firefox\69.0.2 (x64 nl)\Main'
            Keys = 'Install Directory', 'PathToExe'
        },
        @{
            Function = 'Snow License Manager - SLM'
            Registry = 'HKEY_LOCAL_MACHINE\SOFTWARE\VideoLAN\VLC'
            Keys = 'InstallDir', 'Version'
        },
        @{
            Function = 'Product 1 - P1'
            Registry = 'HKEY_LOCAL_MACHINE\SOFTWARE\VideoLAN\VLC'
        },
        @{
            Function = 'Product 2 - P2'
            Registry = 'HKEY_LOCAL_MACHINE\SOFTWARE\Product'
            Keys = 'K1', 'K2'
        },
        @{
            Function = 'Snow Integration Manager - SIM'
        }
    )
}
