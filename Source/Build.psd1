@{
    Path = "PSModule-Base.psd1"
    OutputDirectory = "$( $env:OneDrive )\Modules\Personal\PSModule-Base"
    VersionedOutputDirectory = $true
    CopyDirectories = @( 'en-US', 'nl-NL', 'tests' )
}
