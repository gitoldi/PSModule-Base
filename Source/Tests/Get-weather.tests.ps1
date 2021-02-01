$ScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$ScriptRoot = Split-Path -Parent $ScriptRoot
$PesterName = [ io.path ]::GetFileNameWithoutExtension( $myinvocation.mycommand.name )
$ScriptName = $PesterName -replace '.tests',''
$WHColor = @{
    ForegroundColor = 'Magenta'
    BackgroundColor = 'Black'
}

$Line01 = "Weather report: gouda"
$Line09 = @( 'Morning', 'Noon', 'Evening', 'Night' )
if ( Get-Command Get-Weather ) {
    Write-Host -Object "$(Get-TimeStamp) $($PesterName) Get-Weather found."
    $GWOutput = Get-Weather -City gouda
}
else {
    Write-Host -Object "$(Get-TimeStamp) $($PesterName) Get-Weather NOT found."
    $GWOutput = @()
}

Describe "Test : Get-Weather for Gouda" {

    #$TestTxt = "Test command : Get-Weather"
    #Write-Host $TestTxt
    It "Test command : Get-Weather" {
        if ( $GWOutput ) { $TmpTest = $true } else { $TmpTest = $false }
        $TmpTest | Should -Be $true
    }

    It "First line check -> Weather report: gouda" {
        $GWOutput[ 0 ] | Should -Be $Line01
    }

    It "Ninth line check -> morning, noon, evening, night" {
        #Write-Host "`tLine to check: $( $GWOutput[ 9 ])"
        Write-Host -Object "$(Get-TimeStamp) $($PesterName) Testing for       : " -NoNewline
        foreach ( $PartOfDay in $Line09 ) {
            Write-Host "$( $PartOfDay ), " -NoNewline
            ( $GWOutput[ 9 ] -match "$( $PartOfDay )" ) | Should -Be $true
        }
        Write-Host ''
    }

}