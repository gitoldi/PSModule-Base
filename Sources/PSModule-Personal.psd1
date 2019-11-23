@{
    # The module version should be SemVer.org compatible
    ModuleVersion          = "0.2.4"

    # PrivateData is where all third-party metadata goes
    PrivateData            = @{
        # PrivateData.PSData is the PowerShell Gallery data
        PSData             = @{
            # Prerelease string should be here, so we can set it
            Prerelease     = 'beta'

            # Release Notes have to be here, so we can update them
            ReleaseNotes   = 'See CHANGELOG.md'

            # Tags applied to this module. These help with module discovery in online galleries.
            Tags           = 'Marcel Rijsbergen', 'PowerShell', 'GitHub', 'PowerShell module', 'module'

            # A URL to the license for this module.
            LicenseUri     = 'https://github.com/gitoldi/PSModule-Personal/blob/master/LICENSE' # 'https://github.com/PoshCode/ModuleBuilder/blob/master/LICENSE'

            # A URL to the main website for this project.
            ProjectUri     = 'https://github.com/gitoldi/PSModule-Personal' # 'https://github.com/PoshCode/ModuleBuilder'

            # A URL to an icon representing this module.
            IconUri        = '' # 'https://github.com/PoshCode/ModuleBuilder/blob/resources/ModuleBuilder.png?raw=true'
        } # End of PSData
    } # End of PrivateData

    # The main script module that is automatically loaded as part of this module
    RootModule             = 'PSModule-Personal.psm1'

    # Modules that must be imported into the global environment prior to importing this module
    RequiredModules        = @(
        'Configuration'     # https://github.com/PoshCode/Configuration
    )

    # Always define FunctionsToExport as an empty @() which will be replaced on build
    FunctionsToExport      = @()

    # ID used to uniquely identify this module
    # GUID created 191004 MR.
    GUID                   = '19e690f4-6c92-4b96-ad0e-9d9fabe54cf5'
    Description            = 'A module for some Snow Software checks.'

    # Common stuff for all our modules:
    CompanyName            = 'Private'
    Author                 = 'Marcel Rijsbergen'
    Copyright              = "Copyright 2018 - today, Marcel Rijsbergen"

    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion      = '5.1'
    CompatiblePSEditions = @( 'Core','Desktop' )
}
