$Line01 = "Weather report: gouda"
$Line09 = @( 'Morning', 'Noon', 'Evening', 'Night' )
if ( Get-Command Get-Weather ) {
    $GWOutput = Get-Weather -City gouda
}

Describe "Test : Get-Weather for Gouda" {

    #$TestTxt = "Test command : Get-Weather"
    #Write-Host $TestTxt
    It "Test command : Get-Weather" {
        if ( $GWOutput ) { $TmpTest = $true } else { $TmpTest = $false }
        $TmpTest | Should be $true
    }

    It "First line check -> Weather report: gouda" {
        $GWOutput[ 0 ] | Should Be $Line01
    }

    It "Ninth line check -> morning, noon, evening, night" {
        #Write-Host "`tLine to check: $( $GWOutput[ 9 ])"
        Write-Host "`tTesting for       : " -NoNewline
        foreach ( $PartOfDay in $Line09 ) {
            Write-Host "$( $PartOfDay ), " -NoNewline
            ( $GWOutput[ 9 ] -match "$( $PartOfDay )" ) | Should Be $true
        }
        Write-Host ''
    }

}