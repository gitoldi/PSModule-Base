@{
    Path = "PSModule-Personal.psd1"
    OutputDirectory = "$( $env:USERPROFILE )\Documenten\WindowsPowerShell\Modules"
    VersionedOutputDirectory = $true
    CopyDirectories = @( 'en-US', 'nl-NL' )
}
