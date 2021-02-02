<#
.SYNOPSIS
    Short description
.DESCRIPTION
    Long description
.EXAMPLE
    PS C:\> <example usage>
    Explanation of what the example does
.INPUTS
    Inputs (if any)
.OUTPUTS
    Output (if any)
.NOTES
    General notes
#>
[ CmdletBinding( )]
$ScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$ScriptRoot = Split-Path -Parent $ScriptRoot
$PesterName = [ io.path ]::GetFileNameWithoutExtension( $myinvocation.mycommand.name )
$ScriptName = $PesterName -replace '.tests', ''
$WHColor    = @{
    ForegroundColor = 'Magenta'
    BackgroundColor = 'Black'
}
$skipPS1Desktop = -not [bool]($PSEdition -match 'Desktop')
$skipPS1Core    = -not [bool]($PSEdition -match 'Core')
Write-Host -Object "$(Get-TimeStamp) $($ScriptName)" @WHColor

#region 'Verify Pester version.'
$PesterVersion = ( Get-Module Pester ).Version
$PesterMajor = $PesterVersion.Major
if ( $PesterMajor -ne 4 ) {
    Write-Warning -Message "$(Get-TimeStamp) $($ScriptName) These test are verified for Pester V4 only."
    Return
}
#endregion 'Verify Pester version.'

#region 'Functions.'
function DoTestMB {
    [ CmdletBinding( )]
    param (
        [ string ] $ScriptName,
        [ Int64 ] $TestNum,
        [ string ] $TestValue,
        [ string] $TestMetric,
        [ switch ] $MiB
    )
    Describe "Convert $($TestNum) should be" {
        # Tests
        if ( $MiB ) {
            $ReturnValue = & $ScriptName -NumberOfBytes $TestNum -MebiBytes
        }
        else {
            $ReturnValue = & $ScriptName -NumberOfBytes $TestNum
        }
        It "...Value  : $($TestValue)" {
            $ReturnValue.Value | Should -Be $TestValue
        }
        It "...Metric : $($TestMetric)" {
            $ReturnValue.Metric | Should -Be $TestMetric
        }
    }
}
#endregion 'Functions.'

#region 'Test MB - MegaByte.'
[int] $MyMultiplier = 1000
Write-Host -Object "$(Get-TimeStamp) $($ScriptName) Convert bytes using multiplier: $($MyMultiplier)" @WHColor
# 1.000
DoTestMB $ScriptName $MyMultiplier "1,00" "KB = KiloByte"

# 1.024
DoTestMB $ScriptName ( $MyMultiplier + 24 ) "1,02" "KB = KiloByte"

# 1.025
    # Bug between Core and Desktop?
    Write-Host ''
    Write-Host -Object "$(Get-TimeStamp) $($ScriptName) Need to research. Bug Desktop vs. Core on 1025?" @WHColor
    # Test the following line on both: "{0:N2}" -f (1025 / 1000)
    
    #region 'Core 1025'
    If ( $skipPS1Desktop ) {
        Write-Host -Object "$(Get-TimeStamp) $($ScriptName) Core returns 1,02 KB." @WHColor
        DoTestMB $ScriptName ( $MyMultiplier + 25 ) "1,02" "KB = KiloByte"
    }
    #endregion 'Core 1025'

    #region 'Desktop 1025'
    If ( $skipPS1Core ) {
        Write-Host -Object "$(Get-TimeStamp) $($ScriptName) Desktop returns 1,03 instead of 1,02 KB." @WHColor
        DoTestMB $ScriptName ( $MyMultiplier + 25 ) "1,03" "KB = KiloByte"
    }
    #endregion 'Desktop 1025'

# 1.026
DoTestMB $ScriptName ( $MyMultiplier + 26 ) "1,03" "KB = KiloByte"

# 1.000.000
DoTestMB $ScriptName ( $MyMultiplier * $MyMultiplier ) "1,00" "MB = MegaByte"

# 1.000.000.000
DoTestMB $ScriptName ( $MyMultiplier * $MyMultiplier * $MyMultiplier ) "1,00" "GB = GigaByte"

# 1.000.000.000.000
DoTestMB $ScriptName ( $MyMultiplier * $MyMultiplier * $MyMultiplier * $MyMultiplier ) "1,00" "TB = TeraByte"

# 1.000.000.000.000.000
DoTestMB $ScriptName ( $MyMultiplier * $MyMultiplier * $MyMultiplier * $MyMultiplier * $MyMultiplier ) "1,00" "PT = PetaByte"

# 1.000.000.000.000.000.000
DoTestMB $ScriptName ( $MyMultiplier * $MyMultiplier * $MyMultiplier * $MyMultiplier * $MyMultiplier * $MyMultiplier ) "1,00" "EB = ExaByte"

# 123.456.789
DoTestMB $ScriptName 123456789 "123,46" "MB = MegaByte"

#endregion 'Test MB - megabyte.'

#region 'Test MiB - MebiByte.'
Write-Host -Object "  $( '-' * 40 )"
# Multiplier
$MyMultiplier = 1024
Write-Host -Object "$(Get-TimeStamp) $($ScriptName) Convert binary using multiplier: $($MyMultiplier)" @WHColor
$PropsMib = @{
    Mib = $true
    ScriptName = $ScriptName
}
# 1.000
DoTestMB @PropsMib 1000 "1.000,00" "B = Byte"
# 1.024
DoTestMB @PropsMib $MyMultiplier "1,00" "KiB = KibiByte"
# 1.024
DoTestMB @PropsMib ( $MyMultiplier + 24 ) "1,02" "KiB = KibiByte"
# 1.025
DoTestMB @PropsMib ( $MyMultiplier + 25 ) "1,02" "KiB = KibiByte"
# 1.026
DoTestMB @PropsMib ( $MyMultiplier + 26 ) "1,03" "KiB = KibiByte"
# 1.000.000
DoTestMB @PropsMib ( $MyMultiplier * $MyMultiplier ) "1,00" "MiB = MebiByte"
# 1.000.000.000
DoTestMB @PropsMib ( $MyMultiplier * $MyMultiplier * $MyMultiplier ) "1,00" "GiB = GibiByte"
# 1.000.000.000.000
DoTestMB @PropsMib ( $MyMultiplier * $MyMultiplier * $MyMultiplier * $MyMultiplier ) "1,00" "TiB = TebiByte"
# 1.000.000.000.000.000
DoTestMB @PropsMib ( $MyMultiplier * $MyMultiplier * $MyMultiplier * $MyMultiplier * $MyMultiplier ) "1,00" "PiB = PebiByte"
# 1.000.000.000.000.000.000
DoTestMB @PropsMib ( $MyMultiplier * $MyMultiplier * $MyMultiplier * $MyMultiplier * $MyMultiplier * $MyMultiplier ) "1,00" "EiB = ExbiByte"
# 123.456.789
DoTestMB @PropsMib 123456789 "117,74" "MiB = MebiByte"
#endregion 'Test MiB - MebiByte.'

Write-Host -Object "  $( '-' * 40 )"
