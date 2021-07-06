function Invoke-TSPingSweep {
    <#
    .SYNOPSIS
    Scan IP-Addresses, Ports and HostNames

    .DESCRIPTION
    Scan for IP-Addresses, HostNames and open Ports in your Network.

    .PARAMETER StartAddress
    StartAddress Range

    .PARAMETER EndAddress
    EndAddress Range

    .PARAMETER ResolveHost
    Resolve HostName

    .PARAMETER ScanPort
    Perform a PortScan

    .PARAMETER Ports
    Ports That should be scanned, default values are: 21, 22, 23, 53, 69, 71,
    80, 98, 110, 139, 111, 389, 443, 445, 1080, 1433, 2001, 2049, 3001, 3128,
    5222, 6667, 6868, 7777, 7878, 8080, 1521, 3306, 3389, 5801, 5900, 5555, 5901

    .PARAMETER TimeOut
    Time (in MilliSeconds) before TimeOut, Default set to 100

    .PARAMETER ShowProgress
    To see a progress bar during processing supply this switch parameter.

    .EXAMPLE
    Invoke-TSPingSweep -StartAddress 192.168.0.1 -EndAddress 192.168.0.254

    .EXAMPLE
    Invoke-TSPingSweep -StartAddress 192.168.0.1 -EndAddress 192.168.0.254 -ResolveHost

    .EXAMPLE
    Invoke-TSPingSweep -StartAddress 192.168.0.1 -EndAddress 192.168.0.254 -ResolveHost -ScanPort

    .EXAMPLE
    Invoke-TSPingSweep -StartAddress 192.168.0.1 -EndAddress 192.168.0.254 -ResolveHost -ScanPort -TimeOut 500

    .EXAMPLE
    Invoke-TSPingSweep -StartAddress 192.168.0.1 -EndAddress 192.168.10.254 -ResolveHost -ScanPort -Port 80

    .EXAMPLE
    How to use.
    PS1> . .\Invoke-TSPingSweep.ps1
    PS1> $AllNodes = Invoke-TSPingSweep -StartAddress 192.168.39.1 -EndAddress 192.168.39.255 -ResolveHost -ScanPort -ShowProgress
    WARNING: 20210703-224043 Invoke-TSPingSweep Cannot get (DNS) hostname for 192.168.39.128.
    20210703-224146 Invoke-TSPingSweep INFO IP's Scanned # 255 - Failed # 246 - Found # 9
    20210703-224146 Invoke-TSPingSweep INFO Time Begin : 07/03/2021 22:39:10 - End : 07/03/2021 22:41:46
    20210703-224146 Invoke-TSPingSweep INFO Run time 0 hours 2 minutes 35 seconds

    PS1> $AllNodes.Nodes.Count
    9

    PS1> $AllNodes.Nodes | ForEach-Object {
        Write-Host $_.IPaddress '-' $_.hostname '-' $_.mac; foreach ( $port in $_.ports ) {
            write-host "`t->" $port.id.ToString().PadLeft(4) $port.function
        }
    }
    192.168.39.1 - router.lan - a1-b2-c3-d4-e5-f6
        ->   53 DNS - Domain Name Server
        ->   80 HTTP - World Wide Web HTTP
    ...
    ...
    192.168.39.128 - www.domain.lan - a7-b8-c9-da-eb-fc
        -> 8080 HTTP Alternate (see port 80)
    PS1> 

    .NOTES
    Goude 2012, TrueSec

    Sources:
    - https://devblogs.microsoft.com/scripting/use-powershell-for-network-host-and-port-discovery-sweeps/
        Assuming his is the original one from Ed Wilson. The link to Invoke-TSPing does not exist anymore.
    - https://github.com/lazywinadmin/PowerShell/pull/31/files#diff-8d3d710689c178fb919afbeb0566a50d29679929be744c9bb8405cd37ae742b5
        Contents seem to comply with the previous link.
    - https://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.xhtml
        IANA list with port ID's and descriptions.
    
    History:
    20210703 MR 1.8.0
        - Added parameter version and made it work in the 'begin - process - end' flow.
        
    20210703 MR 1.7.0
        - Added these history steps.
        - Removed the ports2 in favor of the old ports to become the new ID and function usage.

    20210702 MR 1.6.0
        - Added NodesFailed, NodesFound and NodesTotal to the returned object.
        
    20210702 MR 1.5.0
        - Added a ports2 for test to be from just an ID to a hash containing ID and Function.
        - ID is still ID and function containing a short description.
        - e.g. from just ID = 22 to ID = 22 and Function = 'SSH - Secure Shell Protocol'

    20210702 MR 1.4.0
        - Modified line '$hostName = ([Net.DNS]::EndGetHostEntry([IAsyncResult]$getHostEntry)).HostName'
        - to be within a try catch block to minimize errors.

    20210702 MR 1.3.0
        - Tested on node at customer site.
        - Many errors when resolvehost does not work.
        - But the returned object worked nicely.

    20210701 MR 1.2.0
        - Added parameter 'ShowProgress'.

    20210701 MR 1.1.0
        - Added a lot of 'Verbose'.

    20210701 MR 1.0.0
        - First working version from source.
    #>

    #region 'Initialization'
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    Param (
        [parameter(Mandatory = $true, Position = 0, ParameterSetName = 'Default')]
        [ValidatePattern("\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b")]
        [string] $StartAddress
        ,
        [parameter(Mandatory = $true, Position = 1, ParameterSetName = 'Default')]
        [ValidatePattern("\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b")]
        [string] $EndAddress
        ,
        [parameter(ParameterSetName = 'Default')]
        [switch] $ResolveHost
        ,
        [parameter(ParameterSetName = 'Default')]
        [switch] $ScanPort
        ,
        #[int[]] $Ports = @(21,22,23,53,69,71,80,98,110,139,111,389,443,445,1080,1433,2001,2049,3001,3128,5222,6667,6868,7777,7878,8080,1521,3306,3389,5801,5900,5555,5901)
        #,
        [parameter(ParameterSetName = 'Default')]
        [array] $Ports = @(
            @{ID = 21; Function = 'FTP - File Transfer Protocol'},
            @{ID = 22; Function = 'SSH - Secure Shell Protocol'},
            @{ID = 23; Function = 'Telnet'},
            @{ID = 53; Function = 'DNS - Domain Name Server'},
            @{ID = 69; Function = 'Trivial File Transfer'},
            @{ID = 71; Function = 'Remote Job Service'},
            @{ID = 80; Function = 'HTTP - World Wide Web HTTP'},
            @{ID = 98; Function = 'TAC News'},
            @{ID = 110; Function = 'POP3 - Post Office Protocol - Version 3'},
            @{ID = 111; Function = 'SUN Remote Procedure Call'},
            @{ID = 139; Function = 'NETBIOS Session Service'},
            @{ID = 389; Function = 'LDAP - Lightweight Directory Access Protocol'},
            @{ID = 443; Function = 'HTTPS - http protocol over TLS/SSL'},
            @{ID = 445; Function = 'Microsoft-DS'},
            @{ID = 1080; Function = 'Socks'},
            @{ID = 1433; Function = 'Microsoft-SQL-Server'},
            @{ID = 1521; Function = 'nCube License Manager'},
            @{ID = 2001; Function = 'curry'},
            @{ID = 2049; Function = 'Network File System'},
            @{ID = 3001; Function = 'OrigoDB Server Native Interface'},
            @{ID = 3128; Function = 'Active API Server Port'},
            @{ID = 3306; Function = 'MySQL'},
            @{ID = 3389; Function = 'MS WBT Server'},
            @{ID = 5222; Function = 'XMPP Client Connection'},
            @{ID = 5555; Function = 'Personal Agent'},
            @{ID = 5801; Function = 'VNC or Unassigned'},
            @{ID = 5900; Function = 'Remote Framebuffer'},
            @{ID = 5901; Function = 'VNC-1 or Unassigned'},
            @{ID = 6667; Function = 'IRCU'},
            @{ID = 6868; Function = 'Acctopus Command Channel or Status'},
            @{ID = 7777; Function = 'cbt'},
            @{ID = 7878; Function = 'Opswise Message Service'},
            @{ID = 8080; Function = 'HTTP Alternate (see port 80)'}
        )
        ,
        [parameter(ParameterSetName = 'Default')]
        [int] $TimeOut = 100
        ,
        [parameter(ParameterSetName = 'Default')]
        [switch] $ShowProgress
        ,
        [parameter(ParameterSetName = 'Version')]
        [switch] $Version
    )
    #endregion 'Initialization'

    Begin {
        #region 'Functions'

        #region 'Function - Get-TimeStamp'
        function Get-TimeStamp {
            Return (Get-Date -UFormat "%Y%m%d-%H%M%S")
        }
        #endregion 'Function - Get-TimeStamp'

        #endregion 'Functions'

        # Script info
        $ScriptName = [ io.path ]::GetFileNameWithoutExtension( $MyInvocation.MyCommand.Name )
        Write-Verbose -Message "$( Get-TimeStamp ) $( $ScriptName ) INFO Begin."
        [ version ] $ScriptVersion = '1.7.0'
        if ( $Version ) {
            Write-Verbose -Message "$( Get-TimeStamp ) $( $ScriptName ) INFO Version : $( $ScriptVersion )"
            #Return $ScriptVersion
        }
        else {
            # Set variables
            # First get start time.
            $TimeBegin = Get-Date

            # Variables.
            $NodesAll    = @()
            $NodesFailed = 0
            $NodesFound  = 0
            $NodesTotal  = 0
            $ping        = New-Object System.Net.Networkinformation.Ping
        }
    }
    Process {
        Write-Verbose -Message "$( Get-TimeStamp ) $( $ScriptName ) INFO Process."

        if ( $Version ) {
            Write-Verbose -Message "$( Get-TimeStamp ) $( $ScriptName ) INFO Parameter 'Verbose' selected, skip processing."
        }
        else {

            # Process octet 1
            foreach ($a in ($StartAddress.Split(".")[0]..$EndAddress.Split(".")[0])) {
                Write-Verbose -Message "$( Get-TimeStamp ) $( $ScriptName ) INFO Processing octet 1 : $($a)"

                # Process octet 2
                foreach ($b in ($StartAddress.Split(".")[1]..$EndAddress.Split(".")[1])) {

                    Write-Verbose -Message "$( Get-TimeStamp ) $( $ScriptName ) INFO              octet 2 : $($b)"

                    # Process octet 3
                    foreach ($c in ($StartAddress.Split(".")[2]..$EndAddress.Split(".")[2])) {
                        Write-Verbose -Message "$( Get-TimeStamp ) $( $ScriptName ) INFO                octet 3 : $($c)"
                    
                        # Process octet 4
                        foreach ($d in ($StartAddress.Split(".")[3]..$EndAddress.Split(".")[3])) {
                            Write-Verbose -Message "$( Get-TimeStamp ) $( $ScriptName ) INFO                  octet 4 : $($d)"

                            # Set variables.
                            $NodesTotal++
                            $IPTemp = "$a.$b.$c.$d"

                            # Show progress bar 1
                            if ($ShowProgress) {
                                $HashProgress = @{
                                    ID              = 1
                                    Activity        = 'PingSweep'
                                    Status          = "$($IPTemp)"
                                    Percentcomplete = (($d/($EndAddress.Split(".")[3])) * 100)
                                }
                                write-progress @HashProgress
                            }

                            # Ping node
                            $pingStatus = $ping.Send("$($IPTemp)",$TimeOut)
                            if ($pingStatus.Status -eq "Success") {

                                # If ping is OK and parameter 'ResolveHost' get host info.
                                if ($ResolveHost) {

                                    # If parameter 'ShowProgress' is supplied show progress bar.
                                    if ($ShowProgress) {
                                        $HashProgress1 = @{
                                            ID              = 2
                                            Activity        = 'ResolveHost'
                                            Status          = "$($IPTemp)"
                                            Percentcomplete = (($d/($EndAddress.Split(".")[3])) * 100)
                                        }
                                        write-progress @HashProgress1
                                    }
                                    #else {
                                    #    Write-Host -Object '+' -NoNewline
                                    #}
                                    $getHostEntry = [Net.DNS]::BeginGetHostEntry($pingStatus.Address, $null, $null)
                                }

                                # If parameter 'ScanPort' is supplied, scan ports on the node.
                                if ($ScanPort) {
                                    $openPorts = @()
                                    for ($i = 1; $i -le $ports.Count; $i++) {
                                        #$port = $Ports[($i-1)]
                                        $port = $Ports[($i-1)]

                                        # If parameter 'ShowProgress' is supplied show progress bar.
                                        if ($ShowProgress) {
                                            $HashProgress2 = @{
                                                ID              = 3
                                                Activity        = 'PortScan'
                                                Status          = "$($IPTemp)"
                                                Percentcomplete = (($i/($Ports.Count)) * 100)
                                            }
                                            #write-progress -activity PortScan -status "$($IPTemp)" -percentcomplete (($i/($Ports.Count)) * 100) -Id 2
                                            write-progress @HashProgress2
                                        }
                                        $client = New-Object System.Net.Sockets.TcpClient
                                        $beginConnect = $client.BeginConnect($pingStatus.Address, $port.ID, $null, $null)
                                        if ($client.Connected) {
                                            $openPorts += $port
                                        } else {
                                            # Wait
                                            Start-Sleep -Milliseconds $TimeOut
                                            if ($client.Connected) {
                                                $openPorts += $port
                                            }
                                        }
                                        $client.Close()
                                    }
                                }

                                # If parameter 'ResolveHost' is supplied try to resolve IP into name.
                                if ($ResolveHost) {
                                    try {
                                        $hostName = ([Net.DNS]::EndGetHostEntry([IAsyncResult]$getHostEntry)).HostName
                                    }
                                    catch {
                                        $TextMsg = "Cannot get (DNS) hostname for $($IPTemp)."
                                        Write-Warning -Message "$( Get-TimeStamp ) $( $ScriptName ) $($TextMsg)"
                                    }
                                }

                                # Try to get MAC address for this IP.
                                $ArpTmp = arp -a "$($IPTemp)"
                                Write-Verbose -Message "-> $($ArpTmp)"
                                #
                                #Interface: 192.168.39.51 --- 0x3
                                #Internet Address      Physical Address      Type
                                #192.168.39.1          c4-ad-34-5f-75-5f     dynamic

                                $ArpLine = ($ArpTmp[3] -replace '\s+', '#').Split('#')
                                Write-Verbose -Message "-> $($ArpLine)"
                                #
                                #192.168.39.1
                                #c4-ad-34-5f-75-5f
                                #dynamic

                                $MacAddress = $ArpLine[2]
                                Write-Verbose -Message "-> $($MacAddress)"

                                # Return Object
                                #New-Object PSObject -Property @{
                                #    IPAddress = "$($IPTemp)";
                                #    HostName = $hostName;
                                #    MAC = "$MacAddress";
                                #    Ports = $openPorts
                                #} | Select-Object IPAddress, HostName, Ports, Mac
                                $NodeHash = [PSCustomObject]@{
                                    IPAddress = "$($IPTemp)";
                                    HostName  = $hostName;
                                    MAC       = "$MacAddress";
                                    Ports     = $openPorts
                                }
                                $NodesAll += $NodeHash
                                $NodesFound++
                            }
                            else {
                                #Write-Host -Object '.' -NoNewline
                                $NodesFailed++
                            }
                        }
                    }
                }
            }
            #Write-Host -Object ''
        }
    }
    End {
        # Ending
        if ( $Version ) {
            Return $ScriptVersion
        }
        else {
            # MetaData
            $TimeEnd = Get-Date
            $TimeDiff = $TimeEnd - $TimeBegin
            $TimeAvg = $TimeDiff.TotalSeconds / $NodesTotal
            $TextMsg = "IP's Scanned # $($NodesTotal) - Failed # $($NodesFailed) - Found # $($NodesFound)"
            Write-Host -Object "$( Get-TimeStamp ) $( $ScriptName ) INFO $($TextMsg)"
            $TextMsg = "Time Begin : $($TimeBegin) - End : $($TimeEnd)"
            Write-Host -Object "$( Get-TimeStamp ) $( $ScriptName ) INFO $($TextMsg)"
            $TextMsg = "Run time $($TimeDiff.Hours) hours $($TimeDiff.Minutes) minutes $($TimeDiff.Seconds) seconds"
            Write-Host -Object "$( Get-TimeStamp ) $( $ScriptName ) INFO $($TextMsg)"

            Write-Verbose -Message "$( Get-TimeStamp ) $( $ScriptName ) INFO End."
            [PSCustomObject]@{
                Nodes    = $NodesAll
                Found    = $NodesFound
                Failed   = $NodesFailed
                Total    = $NodesTotal
                TimeDiff = $TimeDiff
            }
        }
    } 
}