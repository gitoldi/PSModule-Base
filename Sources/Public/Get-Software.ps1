function Get-Software {
    <#
    .SYNOPSIS
    Get installed software based on the 'uninstall' registry key.

    .DESCRIPTION
    Get installed software based on the 'uninstall' registry key.

    .EXAMPLE

    .PARAMETER Version [<SwitchParameter>]
    Will show the version of the script and exit.

    .INPUTS
    The defined parameters.

    .OUTPUTS
    The PSCustomObject will be shown in the default table format.

    .NOTES
    Sources:
    - https://mcpmag.com/articles/2017/07/27/gathering-installed-software-using-powershell.aspx

    History:
    - 191128 MR
        - 1.0.1 Created this version based on above source.
            Modified parts to comply to my setup.
            Added PSCustomObject.

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
        ,
        [Parameter( )]
        [ string ] $DebugSW = 'xyz123'
    )
    #EndRegion 'Initialize.'

    #Region 'Block Begin.'
    Begin {
        # Get name and return version if requested.
        $ScriptName = '(F)' + [io.path]::GetFileNameWithoutExtension( $MyInvocation.MyCommand.Name )
        Write-Verbose "$( Get-TimeStamp ) $( $ScriptName ) INFO Part: Begin."
        [ version ] $ScriptVersion = '1.0.1'
        if ( $Version ) {
            Write-Host "$( Get-TimeStamp ) $( $ScriptName ) INFO Test if Version was requested: $( $ScriptVersion )"
            Break
        }
    }
    #EndRegion 'Block Begin.'

    #Region 'Block Process.'
    Process {
        Write-Verbose "$( Get-TimeStamp ) $( $ScriptName ) INFO Part: Process."
        ForEach  ( $Computer in  $Computername ) {
            Write-Verbose "$( Get-TimeStamp ) $( $ScriptName ) INFO Check host: $( $Computer )"
            If ( Test-Connection -ComputerName  $Computer -Count  1 -Quiet ) {
                Write-Verbose "$( Get-TimeStamp ) $( $ScriptName ) INFO Check registry keys."
                $Paths = @(
                    "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall",
                    "SOFTWARE\\Wow6432node\\Microsoft\\Windows\\CurrentVersion\\Uninstall"
                )
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

                    # Drill down into the Uninstall key using the OpenSubKey Method.
                    Try {
                        $regkey = $reg.OpenSubKey( $Path )
                        Write-Host "$( Get-TimeStamp ) $( $ScriptName ) INFO Drilldown into 'Uninstall' key for: $( $regkey )"

                        # Retrieve an array of string that contain all the subkey names.
                        $subkeys = $regkey.GetSubKeyNames()
                        $subkeysCount = $subkeys.count
                        Write-Host "$( Get-TimeStamp ) $( $ScriptName ) INFO Subkeys found # $( $subkeysCount )"

                        # Open each Subkey and use GetValue Method to return the required values for each.
                        $TempCounter = 1
                        ForEach ( $key in $subkeys ) {
                            $TmpDbg = $DebugSW
                            Write-Verbose "`t...Testing Key $( $TempCounter.ToString().PadLeft( 3 )) : $Key"
                            $thisKey = $Path + "\\" + $key
                            Try {
                                $thisSubKey = $reg.OpenSubKey( $thisKey )
                                if ( $key -eq $TmpDbg ) {
                                    Write-Host ( '-' * 80 )
                                    Write-Host '......subkey'
                                    $thisSubKey | Format-List *
                                    Write-Host '......Getvalues:'
                                }
                                
                                # Prevent Objects with empty DisplayName
                                Write-Verbose "`t......DisplayName"
                                $DisplayName = $thisSubKey.getValue( "DisplayName" )
                                #If ( $DisplayName -AND $DisplayName -notmatch '^Update  for|rollup|^Security Update|^Service Pack|^HotFix' ) {
                                If ( $DisplayName ) {
                                    Write-Verbose "`t......Date"
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
                                    Write-Verbose "`t......Publisher"
                                    $Publisher = Try {
                                        $thisSubKey.GetValue( 'Publisher' ).Trim()
                                    }
                                    Catch {
                                        $thisSubKey.GetValue( 'Publisher' )
                                    }

                                    Write-Verbose "`t......Displayversion"
                                    $KeyVersion = Try {
                                        # Some weirdness with trailing [char]0 on some strings.
                                        $thisSubKey.GetValue( 'DisplayVersion' ).TrimEnd(([ char[ ]]( 32, 0 )))
                                    }
                                    Catch {
                                        $thisSubKey.GetValue( 'DisplayVersion' )
                                    }

                                    Write-Verbose "`t......Uninstallstring"
                                    $UninstallString = Try {
                                        $thisSubKey.GetValue( 'UninstallString' ).Trim()
                                    }
                                    Catch {
                                        $thisSubKey.GetValue( 'UninstallString' )
                                    }

                                    Write-Verbose "`t......Installlocation"
                                    $InstallLocation = Try {
                                        $thisSubKey.GetValue( 'InstallLocation' ).Trim()
                                    }
                                    Catch {
                                        $thisSubKey.GetValue( 'InstallLocation' )
                                    }

                                    Write-Verbose "`t......InstallSource"
                                    $InstallSource = Try {
                                        $thisSubKey.GetValue( 'InstallSource' ).Trim()
                                    }
                                    Catch {
                                        $thisSubKey.GetValue( 'InstallSource' )
                                    }

                                    Write-Verbose "`t......HelpLink"
                                    $HelpLink = Try {
                                        $thisSubKey.GetValue( 'HelpLink' ).Trim()
                                    }
                                    Catch {
                                        $thisSubKey.GetValue( 'HelpLink' )
                                    }

                                    Write-Verbose "`t......PSCustomObject"
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
                                        HelpLink = $thisSubKey.GetValue( 'HelpLink' )
                                        EstimatedSizeMB = [ decimal ]([ math ]::Round((
                                                $thisSubKey.GetValue( 'EstimatedSize' ) * 1024 ) / 1MB,
                                                2
                                        ))
                                    }
                                    $Object.pstypenames.insert( 0, 'System.Software.Inventory' )
                                    Write-Output $Object
                                }
                            }
                            Catch {
                                Write-Warning "$Key : $_"
                            }
                            if ( $key -eq $TmpDbg ) {
                                Read-Host -Prompt 'Hit [Enter] to continue.'
                                Write-Host ( '-' * 80 )
                            }
                            $TempCounter++
                        }
                    }
                    Catch {
                        #   
                    }
                    $reg.Close()
                }
            }
            Else {
                Write-Error "$($Computer): unable to reach remote system!"
            }
        } 
    }
    #EndRegion 'Block Process.'

    #Region 'Block End.'
    End {
        Write-Verbose "$( Get-TimeStamp ) $( $ScriptName ) INFO Part: End."
    }
    #EndRegion 'Block End.'
}
