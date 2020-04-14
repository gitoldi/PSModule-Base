@{
    <#
    File        : PSModule-Base-Config.psd1
    Purpose     : Settings for my Base GitHub PowerShell Module.
    Version     : 1.0
    Source      : 
        - https://docs.microsoft.com/en-us/powershell/dsc/configurations/configdata
        - DSC descriptions, but they mostly use different type (XML).
    Usage       :

    PS> $xx = Import-PowerShellDataFile -Path <full-path-to-configfile.psd1>
    PS> $xx
    Name                           Value
    ----                           -----
    Personal                       {System.Collections.Hashtable, System.Collections.Hashtable, System.Collections.Hashtable}
    Folders                        {Config, Logs, Html, Output...}

    PS> $xx.Personal.Where{ $_.vendor -eq 'microsoft' }.mail
    <user>@outlook.com

    Created     : 191003
    History     :
    - 191003 MR. Config file for PowerShell.

    #>

    Folders = @(
        # In my environment i check if these folders exist in $env:userprofile'\documents'.
        # If not they will be created.
        'Config',   # Will contain configuration files, some of which are for PowerShell.
        'Logs',     # Will contain logfiles.
        'Html',     # Will contain output HTML files. e.g. for https://github.com/azurefieldnotes/ReportHTML
        'Output',   # Will contain all sorts of output like: csv, xml, pdf
        'Temp'      # Can be used for temporary files.
    )

    Personal = @(
        @{
            Vendor = 'GitHub'
            Username = '<username>'
            Mail = '<user>@<maildomain>'
        },
        @{
            Vendor = 'Google'
            Username = '<username>'
            Mail = '<user>@gmail.com'
        },
        @{
            Vendor = 'Microsoft'
            Username = '<username>'
            Mail = '<user>@outlook.com'
        }
    )
}
