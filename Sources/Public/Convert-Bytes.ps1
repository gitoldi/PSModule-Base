# Function Start: Convert-Bytes
function Convert-Bytes( ) {
    <#
    .SYNOPSIS
    Convert bytes to KB, MB, GB, etc.

    .DESCRIPTION
    Convert bytes to KB, MB, GB, etc.
    Use 1000 for calculations, NOT 1024.
    See : https://nl.wikipedia.org/wiki/Megabyte

    .EXAMPLE
    PS C:\> Convert-Bytes -CurBytes 10000
    10,00 MB

    .INPUTS
    Maximum a 64-bit integer.

    .OUTPUTS
    The integer given is converted to a MB, GB, TB, ... output.

    .NOTES
    History:

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
        [ Long ] $CurBytes,

        [ Switch ] $Version
    )

    #
    #******************************************************************
    # Do parameter checking.
    # Set current (sub)routine name.
    #
    $CurFunc = [io.path]::GetFileNameWithoutExtension( $MyInvocation.MyCommand.Name )
    [ version ] $ScriptVersion = '1.0.5'
    if ( $Version ) {
        Write-Verbose "$CurFunc version : $ScriptVersion"
        Return $ScriptVersion
    }

    # Define some variables to use in calculation.
    # Disk manufacturers use 1000. MB = 1000
    Write-Verbose "$( Get-TimeStamp ) $( $CurFunc ) Set variables (based on 1000)."
    $CurKB = 1000           # Kilobyte
    $CurMB = $CurKB * 1000  # Megabyte
    $CurGB = $CurMB * 1000  # Gigabyte
    $CurTB = $CurGB * 1000  # Terabyte
    $CurPB = $CurTB * 1000  # Petabyte
    $CurEB = $CurPB * 1000  # Exabyte
    $CurZB = $CurEB * 1000  # Zettabyte
    # Yottabyte
    # Brontobyte
    # Geopbyte
    # Saganbyte
    # Pijabyte

    # IEC use 1024. MiB = 1024
    Write-Verbose "$( Get-TimeStamp ) $( $CurFunc ) Set variables (based on 1024)."
    $CurKiB = 1024          # KibiByte
    # MebiMyte 

    # Max values.
    Write-Verbose "$( Get-TimeStamp ) $( $CurFunc ) Set some maximum levels."
    $Int32Max =  4294967295
    $Int64Max =  18446744073709551615

    #Write-Host $CurFunc '-' $CurBytes
    Write-Verbose "$( Get-TimeStamp ) $( $CurFunc ) Calculate value to readable text for output."
    if (( $CurBytes -lt 1 ) -or ( $CurBytes -gt $Int64Max ))
    {
        Write-Warning "$( $CurFunc ) Value is outside the range for PowerShell type 'Long'."
    }
    elseif ( $CurBytes -ge $CurZB )
    {
        $CurText = "ZB"
        $CurNum = $CurBytes / $CurZB
    }
    elseif ( $CurBytes -ge $CurEB )
    {
        $CurText = "EB"
        $CurNum = $CurBytes / $CurEB
    }
    elseif ( $CurBytes -ge $CurPB )
    {
        $CurText = "PB"
        $CurNum = $CurBytes / $CurPB
    }
    elseif ( $CurBytes -ge $CurTB )
    {
        $CurText = "TB"
        $CurNum = $CurBytes / $CurTB
    }
    elseif ( $CurBytes -ge $CurGB )
    {
        $CurText = "GB"
        $CurNum = $CurBytes / $CurGB
    }
    elseif ( $CurBytes -ge $CurMB )
    {
        $CurText = "MB"
        $CurNum = $CurBytes / $CurMB
    }
    else
    {
        $CurText = "Bytes"
        $CurNum = $CurBytes
    }

    Write-Verbose "$( Get-TimeStamp ) $( $CurFunc ) Setup final number text and return the info."
    $CurNum = "{0:N2}" -f $CurNum
    Return "$( $CurNum ) $( $CurText )"

}
# Function End: Convert-Bytes
