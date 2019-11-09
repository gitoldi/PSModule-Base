@{
    Path = "PSModule-Personal.psd1"
    OutputDirectory = "$( $env:USERPROFILE )\Documents\WindowsPowerShell\Modules\PSModule-Personal"
    VersionedOutputDirectory = $true
    CopyDirectories = @( 'en-US', 'nl-NL' )
}
