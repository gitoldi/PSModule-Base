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

#Region 'Test MB - megabyte.'
Describe 'Test convert bytes using 1000 as multiplier (default) MB = megabyte.' {
    # Multiplier
    $Multiplier = 1000

    # Tests
    $TestNum = 1000
    $ReturnValue = Convert-Bytes -NumberOfBytes $TestNum
    Context "Test $( $TestNum ) -> $( $ReturnValue.Value ) $( $ReturnValue.Metric )" {
        It "...Value" {
            $ReturnValue.Value | Should Be "1,00"
        }
        It "...Metric" {
            $ReturnValue.Metric | Should Be "KB = KiloByte"
        }
    }
    $TestNum = 1024
    $ReturnValue = Convert-Bytes -NumberOfBytes $TestNum
    Context "Test $( $TestNum ) -> $( $ReturnValue.Value ) $( $ReturnValue.Metric )" {
        It '...Value' {
            $ReturnValue.Value | Should Be ( "{0:n2}" -f ( $TestNum / $Multiplier ))
        }
        It '...Metric' {
            $ReturnValue.Metric | Should Be "KB = KiloByte"
        }
    }
    $TestNum = 1025
    $ReturnValue = Convert-Bytes -NumberOfBytes $TestNum
    Context "Test $( $TestNum ) - Compare using calculation. -> $( $ReturnValue.Value ) $( $ReturnValue.Metric )" {
        It '...Value' {
            $ReturnValue.Value | Should Be ( "{0:n2}" -f ( $TestNum / $Multiplier ))
        }
        It '...Metric' {
            $ReturnValue.Metric | Should Be "KB = Kilobyte"
        }
    }
    Context "Test $( $TestNum ) - Compare using string. -> $( $ReturnValue.Value ) $( $ReturnValue.Metric )" {
        It "...Value" {
            $ReturnValue.Value | Should Be '1,03'
        }
        It "...Metric" {
            $ReturnValue.Metric | Should Be "KB = Kilobyte"
        }
    }

    $TestNum = 1030
    $ReturnValue = Convert-Bytes -NumberOfBytes $TestNum
    Context "Test $( $TestNum ) -> $( $ReturnValue.Value ) $( $ReturnValue.Metric )" {
        It '...Value' {
            $ReturnValue.Value | Should Be '1,03'
        }
        It '...Metric' {
            $ReturnValue.Metric | Should Be "KB = KiloByte"
        }
    }

    $TestNum = 123456789
    $ReturnValue = Convert-Bytes -NumberOfBytes $TestNum
    Context "Test $( $TestNum ) - Compare using string. -> $( $ReturnValue.Value ) $( $ReturnValue.Metric )" {
        It "...Value" {
            $ReturnValue.Value | Should Be "123,46"
        }
        It "...Metric" {
            $ReturnValue.Metric | Should Be "MB = MegaByte"
        }
    }
}
#EndRegion 'Test MB - megabyte.'

#Region 'Test MiB - mebibyte.'
Describe 'Test convert bytes using 1024 as multiplier (mostly for memory) MiB = mebibyte.' {
    # Multiplier
    $Multiplier = 1024

    # Tests
    $TestNum = 1000
    $ReturnValue = Convert-Bytes -NumberOfBytes $TestNum -MebiBytes
    Context "Test $( $TestNum ) -> $( $ReturnValue.Value ) $( $ReturnValue.Metric )" {
        It "...Value" {
            $ReturnValue.Value | Should Be "1.000,00"
        }
        It "...Metric" {
            $ReturnValue.Metric | Should Be "B = Byte"
        }
    }
    $TestNum = 1024
    $ReturnValue = Convert-Bytes -NumberOfBytes $TestNum -MebiBytes
    Context "Test $( $TestNum ) -> $( $ReturnValue.Value ) $( $ReturnValue.Metric )" {
        It '...Value' {
            $ReturnValue.Value | Should Be ( "{0:n2}" -f ( $TestNum / $Multiplier ))
        }
        It '...Metric' {
            $ReturnValue.Metric | Should Be "KiB = KibiByte"
        }
    }
    $TestNum = 1025
    $ReturnValue = Convert-Bytes -NumberOfBytes $TestNum -MebiBytes
    Context "Test $( $TestNum ) - Compare using calculation. -> $( $ReturnValue.Value ) $( $ReturnValue.Metric )" {
        It '...Value' {
            $ReturnValue.Value | Should Be ( "{0:n2}" -f ( $TestNum / $Multiplier ))
        }
        It '...Metric' {
            $ReturnValue.Metric | Should Be "KiB = KibiByte"
        }
    }
    Context "Test $( $TestNum ) - Compare using string. -> $( $ReturnValue.Value ) $( $ReturnValue.Metric )" {
        It "...Value" {
            $ReturnValue.Value | Should Be '1,00'
        }
        It "...Metric" {
            $ReturnValue.Metric | Should Be "KiB = KibiByte"
        }
    }

    $TestNum = 1030
    $ReturnValue = Convert-Bytes -NumberOfBytes $TestNum -MebiBytes
    Context "Test $( $TestNum ) -> $( $ReturnValue.Value ) $( $ReturnValue.Metric )" {
        It '...Value' {
            $ReturnValue.Value | Should Be '1,01'
        }
        It '...Metric' {
            $ReturnValue.Metric | Should Be "KiB = KibiByte"
        }
    }

    $TestNum = 123456789
    $ReturnValue = Convert-Bytes -NumberOfBytes $TestNum -MebiBytes
    Context "Test $( $TestNum ) - Compare using string. -> $( $ReturnValue.Value ) $( $ReturnValue.Metric )" {
        It "...Value" {
            $ReturnValue.Value | Should Be "117,74"
        }
        It "...Metric" {
            $ReturnValue.Metric | Should Be "MiB = MebiByte"
        }
    }
}
#EndRegion 'Test MiB - mebibyte.'
