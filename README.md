
<h1 id='top'>PSModule-Personal</h1>
PowerShell - A personal module. Using an already existing one to (partly) migrate to and get familiar with Git.

To see a list of changes in this version, refer to the [Changelog](CHANGELOG.md).

<h2>My first attempt to:</h2>

* Setup and use GitHub.
* Get familiar with and use [ModuleBuilder](https://github.com/PoshCode/ModuleBuilder) to prepare to create a module.
    * A way of working to enable building a <module>.psm1 and use some sort of versioning.
* So this repo only contains the files to *build* the module.

Thoughts:
* Keep an eye on the [PSModulePath issue](https://github.com/PowerShell/PowerShell/issues/6850) between PowerShell and PowerShell Core. So putting modules in a 'fixed' place and loading them might need tweaking in your personal environment. There are more PSModulePath issues. See the PowerShell GitHub.
* Usage should be possible in both *PowerShell* and *PoerShell Core*.

<h2>Some Markdown guides</h2>

* [Markdown guide](https://www.markdownguide.org/basic-syntax/)
* [John Gruder - markdown creator](https://daringfireball.net/projects/markdown/)
* [GitHub mastering markdown](https://guides.github.com/features/mastering-markdown/)

<h1 id='build'>Build Module</h1>
Requires the already loaded module *ModuleBuilder* as described and pointed to in [ PSModule-Personal ]( #top ) at the beginning. I'm not explaining the ModuleBuilder but only give a quick summary how to build the final module. People who use ModuleBuilder will know what to change. For others I'll advise to use all the defaults.

After you did a

    git clone https://github.com/gitoldi/PSModule-Personal.git

the tree will be created under the current folder you started the command. Or you might copied and extracted the ZIP in a temporary folder. You might want to modify 'sources\build.psd1'. When running the 'Build-Module' it creates the module in one of the standard PowerShell '$env:PSModulePath' folders. If you want the module in another PowerShell (Core) personal, group or system folder you can modify the 'OutputDirectory' variable. For group or system folder make sure you have the proper (admin) rights. The default setup will create the module in the (sub)folders and files in the given top folder 'PSModule-Personal'.

    PS> Build-Module <full-path-to>\PSModule-Personal\Sources\ -Prefix prefix.ps1 -Suffix suffix.ps1

Now the module is created and you'll find it by default as described in the 'build.psd1'

    PS> Get-ChildItem $env:USERPROFILE'\documents\windowspowershell\modules\psmodule-personal'

    Directory: C:\Users\<username>\documents\windowspowershell\modules\psmodule-personal
    
    Mode                LastWriteTime         Length Name
    ----                -------------         ------ ----
    d-----        10/6/2019   5:01 PM                en-US
    d-----        10/6/2019   5:01 PM                nl-NL
    -a----        10/4/2019   8:27 PM           2479 PSModule-Personal-Config.psd1
    -a----        10/6/2019   5:01 PM           2493 PSModule-Personal.psd1
    -a----        10/6/2019   5:01 PM          16747 PSModule-Personal.psm1

<h1 id='import'>Import module</h1>
The module must be found in one of the standard module paths, see the above mentioned issue.

Since importing modules depends on your personal module tree and setup, in this README I use simple commands.
Personally I link PowerShell (folder WindowPowerShell and file Microsoft.PowerShell_profile.ps1) and PowerShell Core (folder PowerShell and file Profile.ps1) together.

    PS> Import-Module PSModule-Personal

<h2>For Further reading</h2>

* [PowerShell](https://docs.microsoft.com/en-us/powershell/developer/module/modifying-the-psmodulepath-installation-path)

<h1 id='folderroot'>Root folder (Module-Name)</h1>

After the module is build

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
* File - PSModule-Personal.psd1
    * The manifest file for the module.
* File - PSModule-Personal-Config.psd1
    * An example PowerShell configuration file for a module.

<h2 id="build">Build.ps1</h2>

<h2 id="prefix">Prefix.ps1</h2>

<h2 id="suffix">Suffix.ps1</h2>

<h2 id="suffix">PSModule-Personal.psd1</h2>

<h2 id="suffix">PSModule-Personal-Config.psd1</h2>

<h2 id="suffix">PSModule-Personal.[On, Off]</h2>

<h1 id='foldersource'>Folder - Source</h1>

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

<h1>Tested on</h1>

Operation System | PowerShell | PowerShell Core
-------------------------------------------------- | ---------- | ----------
Microsoft Windows 10 Home | 5.1 | 
