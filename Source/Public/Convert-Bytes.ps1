function Convert-Bytes( ) {
    <#
    .SYNOPSIS
    Convert bytes to KB, MB, GB, etc.

    .DESCRIPTION
    Convert bytes to KB, MB, GB, etc.
    Use 1000 (megabyte) for calculations, NOT 1024 (mebibyte).
    See : https://nl.wikipedia.org/wiki/Megabyte

    .EXAMPLE
    PS C:\> Convert-Bytes -NumberOfBytes 10000
    10,00 MB

    .INPUTS
    Maximum a 64-bit integer.

    .OUTPUTS
    The integer given is converted to a MB, GB, TB, ... output.

    .NOTES
    Author      : Marcel Rijsbergen
    History:

    200215 MR
    - 1.1.5 Modified $NumberOfBytes from 'long' to 'uint64'.

    191213 MR
    - 1.0.6 Added explanation megabyte versus mebibyte.

    190512 MR
    - 1.0.5 Changed version to 3 deep.

    190512 MR
    - 1.0.4.0 Minor internal changes, like modify and/or remove spaces in comments.
              Added verbose messages.

    190502 MR
    - 1.0.3.0 Modified the fixed number for 64 bit number to a variable.
              $Int32Max, $Int64Max
    - 1.0.2.0 Added text of numbers greater than zetta.
    - 1.0.1.0 Added KiB.
    - 1.0.0.1 Added switch Version.
    - 0.9.3.0 Modified Version layout.

    18MMDD MR
    - Already in use for some time.

    ToDo:
    - Create a Pester test.
    - Create switches for 1000 or 1024.
    #>

    #
    [ CmdletBinding( )]

    param (
        [ Parameter( )] # Mandatory=$true
        [ uint64 ] $NumberOfBytes
        ,
        [ Switch ] $Version
        ,
        [ Switch ] $MebiBytes
    )

    #
    #******************************************************************
    # Do parameter checking.
    # Set current (sub)routine name.
    #
    $CurFunc = [io.path]::GetFileNameWithoutExtension( $MyInvocation.MyCommand.Name )
    [ version ] $ScriptVersion = '1.1.5'
    if ( $Version ) {
        Write-Verbose "$CurFunc version : $ScriptVersion"
        Return $ScriptVersion
    }

    # Max values.
    Write-Verbose "$( Get-TimeStamp ) $( $CurFunc ) Set some maximum levels."
    $Int32Max = [ uint32 ]::MaxValue # 4294967295
    $Int64Max = [ uint64 ]::MaxValue # 18446744073709551615
    Write-Verbose "$( Get-TimeStamp ) $( $CurFunc ) unsigned 32-bit: $( $Int32Max ) - $( ""{0:N0}"" -f $( $Int32Max ))"
    Write-Verbose "$( Get-TimeStamp ) $( $CurFunc ) unsigned 64-bit: $( $Int64Max ) - $( ""{0:N0}"" -f $( $Int64Max ))"

    # Define some variables to use in calculation.
    $TextStrings = @()
    if ( $MebiBytes ) {
        # Memory is calculated using 1024. MiB = Mebibyte.
        Write-Verbose "$( Get-TimeStamp ) $( $CurFunc ) Set variables (based on 1024)."
        $TextStrings = (
            'B = Byte',
            'KiB = KibiByte',
            'MiB = MebiByte',
            'GiB = GibiByte',
            'TiB = TebiByte',
            'PiB = PebiByte',
            'EiB = ExbiByte',
            'Zib = ZebiByte',
            'YiB = YobiByte'
        )
        $Multiplier = 1024
        $CurKB = 1024                   # Kibibyte
        $CurMB = $CurKB * $Multiplier   # Mebibyte
        $CurGB = $CurMB * $Multiplier   # Gibibyte
        $CurTB = $CurGB * $Multiplier   # Tebibyte
        $CurPB = $CurTB * $Multiplier   # Pebibyte
        $CurEB = $CurPB * $Multiplier   # Exbibyte
        $CurZB = $CurEB * $Multiplier   # Zebibyte
        $CurYB = $CurZB * $Multiplier   # Yobibyte
        # Brontobyte
        # Geopbyte
        # Saganbyte
        # Pijabyte
    }
    else {
        # Disk manufacturers and many other calculations use 1000. MB = 1000
        Write-Verbose "$( Get-TimeStamp ) $( $CurFunc ) Set variables (based on 1000)."
        $TextStrings = (
            'B = Byte',
            'KB = KiloByte',
            'MB = MegaByte',
            'GB = GigaByte',
            'TB = TeraByte',
            'PT = PetaByte',
            'EB = ExaByte',
            'ZB = ZettaByte',
            'YB = YottaByte'
        )
        $Multiplier = 1000
        $CurKB = 1000                   # Kilobyte
        $CurMB = $CurKB * $Multiplier   # Megabyte
        $CurGB = $CurMB * $Multiplier   # Gigabyte
        $CurTB = $CurGB * $Multiplier   # Terabyte
        $CurPB = $CurTB * $Multiplier   # Petabyte
        $CurEB = $CurPB * $Multiplier   # Exabyte
        $CurZB = $CurEB * $Multiplier   # Zettabyte
        $CurYB = $CurZB * $Multiplier   # Yottabyte
        # Brontobyte
        # Geopbyte
        # Saganbyte
        # Pijabyte
    }

    #Write-Host $CurFunc '-' $NumberOfBytes
    Write-Verbose "$( Get-TimeStamp ) $( $CurFunc ) Calculate value to readable text for output."
    if (( $NumberOfBytes -lt 1 ) -or ( $NumberOfBytes -gt $Int64Max )) {
        Write-Warning "$( $CurFunc ) Value is outside the range for PowerShell type 'Long'."
    }
    elseif ( $NumberOfBytes -ge $CurYB ) {
        $CurText = $TextStrings[ 8 ]
        $CurNum = $NumberOfBytes / $CurYB
    }
    elseif ( $NumberOfBytes -ge $CurZB ) {
        $CurText = $TextStrings[ 7 ]
        $CurNum = $NumberOfBytes / $CurZB
    }
    elseif ( $NumberOfBytes -ge $CurEB ) {
        $CurText = $TextStrings[ 6 ]
        $CurNum = $NumberOfBytes / $CurEB
    }
    elseif ( $NumberOfBytes -ge $CurPB ) {
        $CurText = $TextStrings[ 5 ]
        $CurNum = $NumberOfBytes / $CurPB
    }
    elseif ( $NumberOfBytes -ge $CurTB ) {
        $CurText = $TextStrings[ 4 ]
        $CurNum = $NumberOfBytes / $CurTB
    }
    elseif ( $NumberOfBytes -ge $CurGB ) {
        $CurText = $TextStrings[ 3 ]
        $CurNum = $NumberOfBytes / $CurGB
    }
    elseif ( $NumberOfBytes -ge $CurMB ) {
        $CurText = $TextStrings[ 2 ]
        $CurNum = $NumberOfBytes / $CurMB
    }
    elseif ( $NumberOfBytes -ge $CurKB ) {
        $CurText = $TextStrings[ 1 ]
        $CurNum = $NumberOfBytes / $CurKB
    }
    else {
        $CurText = $TextStrings[ 0 ]
        $CurNum = $NumberOfBytes
    }

    Write-Verbose "$( Get-TimeStamp ) $( $CurFunc ) Setup final number text and return the info."
    $CurNum = "{0:N2}" -f $CurNum
    [ PSCustomObject ] @{
        Value = $CurNum
        Metric = $CurText
    }
}
