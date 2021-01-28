# Pester file for module: MarcelRijsbergen
# Used Pester test file as a start.
# Removed some specific Pester stuff.
#
$ScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$ScriptRoot = Split-Path -Parent $ScriptRoot
$PesterName = [ io.path ]::GetFileNameWithoutExtension( $myinvocation.mycommand.name )
$ScriptName = $PesterName -replace '.tests',''
$WHColor = @{
    ForegroundColor = 'Magenta'
    BackgroundColor = 'Black'
}

# DO NOT CHANGE THIS TAG NAME; IT AFFECTS THE CI BUILD.

Describe "Test function : $($ScriptName)" {
    # Testing function : GetCurStamp
    # Format : YYYYMMDD-HHMMSS.mmm
    # Check but leave last '.mmm' of.
    #
    It 'Returned timestamp must be format: YYYYMMDD-HHMMSS[.mmm]' {
        Write-Host -Object "$(Get-TimeStamp) $($PesterName) Example line, see timestamp at beginning of line."
        $PesterStamp = Get-Date -UFormat "%Y%m%d-%H%M%S"
        $FuncStamp = Get-TimeStamp
        $FuncTest = $FuncStamp.Split( "." )
        $FuncTest[0] | Should BeExactly $PesterStamp
    }
}
