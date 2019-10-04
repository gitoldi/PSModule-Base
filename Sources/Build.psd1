@{
    Path = "PSModule-Personal.psd1"
    OutputDirectory = "$( $env:USERPROFILE )\Documents\WindowsPowerShell\Modules\PSModule-Personal"
    VersionedOutputDirectory = $false
    CopyDirectories = @( 'en-US', 'nl-NL' )
}
