function Get-Software {
    <#
    .SYNOPSIS
    Get installed software based on the 'uninstall' registry key.

    .DESCRIPTION
    Get installed software based on the 'uninstall' registry key.

    Sources:
    - https://mcpmag.com/articles/2017/07/27/gathering-installed-software-using-powershell.aspx

    Modified the script a bit to comply to the setup for this module.
    Added 'Write-Verbose' since the script didn't run at first. Left it in.
    Added an extra object per path that contains all the empty/unknown key's.

    .EXAMPLE
    PS [Normal] > get-software

    Computername    : <computername>
    Key             : 7-Zip
    DisplayName     : 7-Zip 18.05 (x64)
    Version         : 18.05
    InstallDate     :
    Publisher       : Igor Pavlov
    UninstallString : D:\Software\7-Zip\Uninstall.exe
    InstallLocation : D:\Software\7-Zip\
    InstallSource   :
    HelpLink        :
    EstimatedSizeMB : 4,93

    .EXAMPLE
    PS [Normal] > get-software -Verbose
    VERBOSE: 20191129-145725.792 (F)Get-Software INFO Part: Begin.
    VERBOSE: 20191129-145725.792 (F)Get-Software INFO Part: Process.
    VERBOSE: 20191129-145725.792 (F)Get-Software INFO Check host: MEKD-PC-01
    VERBOSE: 20191129-145725.811 (F)Get-Software INFO Check registry keys.
    VERBOSE: 20191129-145725.820 (F)Get-Software INFO Checking Path: SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall
    VERBOSE: 20191129-145725.831 (F)Get-Software INFO Drilldown into 'Uninstall' key for: HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall
    VERBOSE: 20191129-145725.836 (F)Get-Software INFO Subkeys found # 50
    VERBOSE:  ...Testing Key   1 : 7-Zip
    VERBOSE:  ......DisplayName, Date, Publisher, Displayversion, Uninstallstring, Installlocation, InstallSource, HelpLink, PSCustomObject

    Computername    : <computername>
    Key             : 7-Zip
    DisplayName     : 7-Zip 18.05 (x64)
    Version         : 18.05
    InstallDate     :
    Publisher       : Igor Pavlov
    UninstallString : D:\Software\7-Zip\Uninstall.exe
    InstallLocation : D:\Software\7-Zip\
    InstallSource   :
    HelpLink        :
    EstimatedSizeMB : 4,93

    .EXAMPLE
    PS [Normal] > $AllSw = get-software -Verbose
    VERBOSE: 20191129-145919.810 (F)Get-Software INFO Part: Begin.
    VERBOSE: 20191129-145919.820 (F)Get-Software INFO Part: Process.
    VERBOSE: 20191129-145919.820 (F)Get-Software INFO Check host: <computername>
    VERBOSE: 20191129-145919.880 (F)Get-Software INFO Check registry keys.
    VERBOSE: 20191129-145919.880 (F)Get-Software INFO Checking Path: SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall
    VERBOSE: 20191129-145919.880 (F)Get-Software INFO Drilldown into 'Uninstall' key for: HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall
    VERBOSE: 20191129-145919.880 (F)Get-Software INFO Subkeys found # 50
    VERBOSE:  ...Testing Key   1 : 7-Zip
    VERBOSE:  ......DisplayName, Date, Publisher, Displayversion, Uninstallstring, Installlocation, InstallSource, HelpLink, PSCustomObject    
    ...

    .EXAMPLE
    PS [Normal] > $AllSw = get-software
    PS [Normal] > $AllSw | Where-Object { $_.displayname -eq 'unknown' }

    Computername    : <computername>
    Key             : 20191129-150020.100 (F)Get-Software INFO No information for the following ( 7 ) keys, AddressBook, Connection Manager, 
                        DirectDrawEx, IE40, IE4Data, IE5BAKEX, IEData
    DisplayName     : Unknown
    Version         :
    InstallDate     : 29-11-2019 15:00:20
    Publisher       :
    UninstallString :
    InstallLocation :
    InstallSource   :
    HelpLink        :
    EstimatedSizeMB : 0

    .PARAMETER Version [<SwitchParameter>]
    Will show the version of the script and exit.

    .INPUTS
    The defined parameters.

    .OUTPUTS
    The PSCustomObject will be shown in the default table format.

    .NOTES
    History:
    - 191129 MR
        - 1.1.4 Added an object per path that contains all empty/unknown key's.
            Gave them the Displayname 'Unknown'. And the key is ALL the empty/unknown ones.
    
    - 191128 MR
        - 1.0.1 Created this version based on above source.
            Modified parts to comply to my setup.

    #>

    #Region 'Initialize.'   
    # OutputType explained on:
    #   https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_outputtypeattribute?view=powershell-6
    [ OutputType( 'System.Software.Inventory' )]
    
    [ CmdletBinding( )]

    param (
        [ Parameter( )]
        [ Switch ] $Version
        ,
        [ Parameter(
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True
        )]
        [ String[ ]] $Computername = $env:COMPUTERNAME
    )
    #EndRegion 'Initialize.'

    #Region 'Block Begin.'
    Begin {
        # Get name and return version if requested.
        $ScriptName = '(F)' + [io.path]::GetFileNameWithoutExtension( $MyInvocation.MyCommand.Name )
        Write-Verbose "$( Get-TimeStamp ) $( $ScriptName ) INFO Part: Begin."
        [ version ] $ScriptVersion = '1.1.4'
        if ( $Version ) {
            Write-Host "$( Get-TimeStamp ) $( $ScriptName ) INFO Test if Version was requested: $( $ScriptVersion )"
            Break
        }
    }
    #EndRegion 'Block Begin.'

    #Region 'Block Process.'
    Process {
        Write-Verbose "$( Get-TimeStamp ) $( $ScriptName ) INFO Part: Process."
        [ array ] $NoSoftware = @()

        #Region 'Loop through all computers.'
        ForEach  ( $Computer in  $Computername ) {
            Write-Verbose "$( Get-TimeStamp ) $( $ScriptName ) INFO Check host: $( $Computer )"
            If ( Test-Connection -ComputerName  $Computer -Count  1 -Quiet ) {
                Write-Verbose "$( Get-TimeStamp ) $( $ScriptName ) INFO Check registry keys."
                $Paths = @(
                    "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall",
                    "SOFTWARE\\Wow6432node\\Microsoft\\Windows\\CurrentVersion\\Uninstall"
                )

                #Region 'Loop through each path.'
                ForEach ( $Path in $Paths ) {
                    Write-Verbose "$( Get-TimeStamp ) $( $ScriptName ) INFO Checking Path: $Path"

                    # Create an instance of the Registry Object and open the HKLM base key.
                    Try {
                        $reg = [ microsoft.win32.registrykey ]::OpenRemoteBaseKey(
                            'LocalMachine',
                            $Computer,
                            'Registry64'
                        )
                    }
                    Catch {
                        Write-Error $_
                        Continue
                    }

                    #Region 'Drill down into the Uninstall key using the OpenSubKey Method.'
                    Try {
                        $regkey = $reg.OpenSubKey( $Path )
                        Write-Verbose "$( Get-TimeStamp ) $( $ScriptName ) INFO Drilldown into 'Uninstall' key for: $( $regkey )"

                        # Retrieve an array of string that contain all the subkey names.
                        $subkeys = $regkey.GetSubKeyNames()
                        $subkeysCount = $subkeys.count
                        Write-Verbose "$( Get-TimeStamp ) $( $ScriptName ) INFO Subkeys found # $( $subkeysCount )"

                        #Region 'Open each Subkey and use GetValue Method to return the required values for each.'
                        $TempCounter = 1
                        ForEach ( $key in $subkeys ) {
                            $TmpDbg = $DebugSW
                            Write-Verbose "`t...Testing Key $( $TempCounter.ToString().PadLeft( 3 )) : $Key"
                            $thisKey = $Path + "\\" + $key

                            #Region 'Try to get subkey information.'
                            Try {
                                $thisSubKey = $reg.OpenSubKey( $thisKey )
                                
                                # Prevent Objects with empty DisplayName
                                $Tmpvalues = "`t......DisplayName"
                                $DisplayName = $thisSubKey.getValue( "DisplayName" )
                                #If ( $DisplayName -AND $DisplayName -notmatch '^Update  for|rollup|^Security Update|^Service Pack|^HotFix' ) {
                                If ( $DisplayName ) {
                                    $Tmpvalues = $Tmpvalues + ', Date'
                                    $Date = $thisSubKey.GetValue( 'InstallDate' )
                                    If ( $Date ) {
                                        Try {
                                            $Date = [ datetime ]::ParseExact( $Date, 'yyyyMMdd', $Null )
                                        }
                                        Catch {
                                            Write-Warning "$( $Computer ): $_ <$( $Date )>"
                                            $Date = $Null
                                        }
                                    }

                                    # Create New Object with empty Properties.
                                    $Tmpvalues = $Tmpvalues + ', Publisher'
                                    $Publisher = Try {
                                        $thisSubKey.GetValue( 'Publisher' ).Trim()
                                    }
                                    Catch {
                                        $thisSubKey.GetValue( 'Publisher' )
                                    }

                                    $Tmpvalues = $Tmpvalues + ', Displayversion'
                                    $KeyVersion = Try {
                                        # Some weirdness with trailing [char]0 on some strings.
                                        $thisSubKey.GetValue( 'DisplayVersion' ).TrimEnd(([ char[ ]]( 32, 0 )))
                                    }
                                    Catch {
                                        $thisSubKey.GetValue( 'DisplayVersion' )
                                    }

                                    $Tmpvalues = $Tmpvalues + ', Uninstallstring'
                                    $UninstallString = Try {
                                        $thisSubKey.GetValue( 'UninstallString' ).Trim()
                                    }
                                    Catch {
                                        $thisSubKey.GetValue( 'UninstallString' )
                                    }

                                    $Tmpvalues = $Tmpvalues + ', Installlocation'
                                    $InstallLocation = Try {
                                        $thisSubKey.GetValue( 'InstallLocation' ).Trim()
                                    }
                                    Catch {
                                        $thisSubKey.GetValue( 'InstallLocation' )
                                    }

                                    $Tmpvalues = $Tmpvalues + ', InstallSource'
                                    $InstallSource = Try {
                                        $thisSubKey.GetValue( 'InstallSource' ).Trim()
                                    }
                                    Catch {
                                        $thisSubKey.GetValue( 'InstallSource' )
                                    }

                                    $Tmpvalues = $Tmpvalues + ', HelpLink'
                                    $HelpLink = Try {
                                        $thisSubKey.GetValue( 'HelpLink' ).Trim()
                                    }
                                    Catch {
                                        $thisSubKey.GetValue( 'HelpLink' )
                                    }

                                    $Tmpvalues = $Tmpvalues + ', PSCustomObject'
                                    Write-Verbose $Tmpvalues
                                    $Object = [ pscustomobject ] @{
                                        Computername = $Computer
                                        Key = $key
                                        DisplayName = $DisplayName
                                        Version = $KeyVersion
                                        InstallDate = $Date
                                        Publisher = $Publisher
                                        UninstallString = $UninstallString
                                        InstallLocation = $InstallLocation
                                        InstallSource  = $InstallSource
                                        HelpLink = $HelpLink
                                        EstimatedSizeMB = [ decimal ]([ math ]::Round((
                                                $thisSubKey.GetValue( 'EstimatedSize' ) * 1024 ) / 1MB,
                                                2
                                        ))
                                    }
                                    $Object.pstypenames.insert( 0, 'System.Software.Inventory' )
                                    Write-Output $Object
                                }
                                else {
                                    $NoSoftware += $key
                                }
                            }
                            Catch {
                                Write-Warning "$Key : $_"
                            }
                            #EndRegion 'Try to get subkey information.'
                            $TempCounter++
                        }
                        #EndRegion 'Open each Subkey and use GetValue Method to return the required values for each.'

                    }
                    Catch {
                        Write-Warning "$( Get-TimeStamp ) $( $ScriptName ) WARNING Should not come here."
                    }
                    #EndRegion 'Drill down into the Uninstall key using the OpenSubKey Method.'

                    #Region 'Finished all paths, finish.'
                    $reg.Close()
                    $TmpText = "$( Get-TimeStamp ) $( $ScriptName ) INFO No information for the following ( $( $NoSoftware.Count )) keys"
                    foreach ( $NoSW in $NoSoftware ) {
                        $TmpText = $TmpText + ", $( $NoSW )"
                    }
                    Write-Verbose "$( $TmpText )."
                    try {
                        $Object = [ pscustomobject ] @{
                            Computername = $Computer
                            Key = "$( $TmpText )"
                            DisplayName = 'Unknown'
                            Version = ''
                            InstallDate = Get-Date
                            Publisher = ''
                            UninstallString = ''
                            InstallLocation = ''
                            InstallSource  = ''
                            HelpLink = ''
                            EstimatedSizeMB = 0
                        }
                        $Object.pstypenames.insert( 0, 'System.Software.Inventory' )
                        Write-Output $Object                    
                    }
                    catch {
                        Write-Host "$( Get-TimeStamp ) $( $ScriptName ) WARNING Error creating object with empty/unknown key's."
                    }
                    #EndRegion 'Finished all paths, finish.'
                }
                #EndRegion 'Loop through each path.'

            }
            Else {
                Write-Error "$( Get-TimeStamp ) $( $ScriptName ) INFO $($Computer): unable to reach remote system!"
            }
        } 
        #EndRegion 'Loop through all computers.'
    }
    #EndRegion 'Block Process.'

    #Region 'Block End.'
    End {
        Write-Verbose "$( Get-TimeStamp ) $( $ScriptName ) INFO Part: End."
    }
    #EndRegion 'Block End.'
}
