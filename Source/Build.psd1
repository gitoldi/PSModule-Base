@{
    Path = "PSModule-Personal.psd1"
    OutputDirectory = "$( $env:OneDrive )\Documenten\WindowsPowerShell\Modules\Personal\PSModule-Personal"
    VersionedOutputDirectory = $true
    CopyDirectories = @( 'en-US', 'nl-NL' )
}
