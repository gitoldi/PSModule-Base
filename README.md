
<h1>PSModule-Personal</h1>
PowerShell - A personal module. Using an already existing one to (partly) migrate to and get familiar with Git.

To see a list of changes in this version, refer to the [Changelog](CHANGELOG.md).

<hr />

<h1>Some Markdown guides</h1>

* [Markdown guide](https://www.markdownguide.org/basic-syntax/)
* [John Gruder - markdown creator](https://daringfireball.net/projects/markdown/)
* [GitHub mastering markdown](https://guides.github.com/features/mastering-markdown/)

<hr />

<h1>PSModule-Personal</h1>

PSModule-Personal is my first attempt to setup and use a module and keep track of using GitHub.
The module consists of a set of simple functions.

Thoughts:
* Maybe I'll be using the build structure which is proposed by the '[ModuleBuilder](https://github.com/PoshCode/ModuleBuilder)' setup.
* Keep an eye on the [PSModulePath issue](https://github.com/PowerShell/PowerShell/issues/6850) between PowerShell and PowerShell Core. So putting modules in a 'fixed' place and loading them might need tweaking in your personal environment. There are more PSModulePath issues. See the PowerShell GitHub.

<h1>Import module</h1>
The module must be found in one of the standard module paths, see the above mentioned issue.

Since importing modules depends on your personal module tree and setup, in this README I use simple commands.
Personally I link PowerShell (folder WindowPowerShell and file Microsoft.PowerShell_profile.ps1) and PowerShell Core (folder PowerShell and file Profile.ps1) together.

    PS> Import-Module PSModule-Personal

<h2>For Further reading</h2>

* [PowerShell](https://docs.microsoft.com/en-us/powershell/developer/module/modifying-the-psmodulepath-installation-path)


<h1>Root folder (Module-Name)</h1>

* File - CHANGELOG.md
    * This file.
    * Keep all modifcations in this file? That is all ps1, psd1, psm1, ...???
* File - README.md (this file)
    * Generic explanation of this module.
* File - LICENSE
    * Current module license.
    * GNU GENERAL PUBLIC LICENSE Version 3.
* File - [Build.psd1](#build)
    * Configuration file for [ 'ModuleBuilder' ]( https://github.com/PoshCode/ModuleBuilder )
    * Trying to combine some suggested way's of working into my module.
* File - [Prefix.ps1](#prefix)
    * Used by ModuleBuilder.
    * The contents of this file will be put at the beginning of the created <module>.psm1 file containing all functions.
* File - [Suffix.ps1](#suffix)
    * Used by ModuleBuilder.
    * The contents of this file will be put at the end of the created <module>.psm1 file containing all functions.

<h2 id="build">Build.ps1</h2>

<h2 id="prefix">Prefix.ps1</h2>

<h2 id="suffix">Suffix.ps1</h2>

<h1>Folder - Source</h1>

* Subfolder - en-US
* Subfolder - nl-NL
* Subfolder - Private
* Subfolder - Public
* Subfolder - Tests
* File - Build.psd1
* File - Tools.psd1

## Subfolder - en-US

## Subfolder - nl-NL

## Subfolder - Private

## Subfolder - Public

<h1>Build Module</h1>

<h1>Update Module</h1>
Copy the last build to the production module folder.
Check modification date and copy if required:
* CHANGELOG.md
* README.md
* tbd
    * module_overview.html
    * and other files that can be used by _DocTreeGenerator_

PS > Robocopy.exe <path-to-folder-for-build>\Build\<module>\<module>\<version>\ <path-to-folder-for-modules>\<module>\<module>\ *.md /V /LEV:0
