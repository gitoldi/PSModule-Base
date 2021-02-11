
<h1 id='top'>PSModule-Base</h1>
PowerShell - A personal module. Using an already existing one to (partly) migrate to and get familiar with Git.

To see a list of changes in this version, refer to the [Changelog](CHANGELOG.md).

<h2>My first (real) attempt to:</h2>

* Setup and use GitHub.
* Get familiar with and use [ModuleBuilder](https://github.com/PoshCode/ModuleBuilder) to prepare to create a module.
    * A way of working to enable building a <module>.psm1 and use versioning (if required).
* So this repo only contains the files to *build* the module. You need to get familiar with _ModuleBuilder_ and (re)create the module in your own environment.

Thoughts:
* Keep an eye on the [PSModulePath issue](https://github.com/PowerShell/PowerShell/issues/6850) between PowerShell and PowerShell Core. So putting modules in a 'fixed' place and loading them might need tweaking in your personal environment. There are more PSModulePath things to consider. See the PowerShell GitHub.
* Usage should be possible in both *PowerShell* and *PowerShell Core*.

<h2>Prerequisites</h2>

The current ```Build.ps1``` points to an output folder for the final module. In my case to a folder in my ```$env:OneDrive``` location. Make sure that folder exists and preferably the main module folder is in your ```$env:PSModulePath```.

<h2>Some Markdown guides</h2>

* [Markdown guide](https://www.markdownguide.org/basic-syntax/)
* [John Gruder - markdown creator](https://daringfireball.net/projects/markdown/)
* [GitHub mastering markdown](https://guides.github.com/features/mastering-markdown/)

<h1 id='build'>Build Module</h1>

Requires the already loaded module *ModuleBuilder* as described at the beginning. I'm not explaining the ModuleBuilder but only give a quick summary how to build the final module. People who use ModuleBuilder will know what to change. For others I'll advise to use all the defaults.

After you did a

    git clone https://github.com/gitoldi/PSModule-Base.git
    set-location PSModule-Base

the tree will be created under the current folder you started the command. You might want to modify 'sources\build.psd1'. When running the 'Build-Module' it creates the module in one of the standard PowerShell [ $env:PSModulePath ]( https://docs.microsoft.com/en-us/powershell/developer/module/modifying-the-psmodulepath-installation-path ) folders. 

The default place will be: $( $env:USERPROFILE )\Documents\WindowsPowerShell\Modules\PSModule-Base

If you want the module in another PowerShell (Core) personal, group or system folder you can modify the 'OutputDirectory' variable. For group or system folder make sure you have the proper (admin) rights. The default setup will create the module in the (sub)folders and files in the given top folder 'PSModule-Base'.

    PS> Build-Module <full-path-to>\PSModule-Base\Sources\ -Prefix prefix.ps1 -Suffix suffix.ps1

Now the module is created and you'll find it in the folder as described in the 'build.psd1'. 

    PS> Get-ChildItem $env:USERPROFILE'\documents\windowspowershell\modules\psmodule-personal'

    Directory: C:\Users\<username>\documents\windowspowershell\modules\psmodule-personal
    
    Mode                LastWriteTime         Length Name
    ----                -------------         ------ ----
    d-----        10/6/2019   5:01 PM                en-US
    d-----        10/6/2019   5:01 PM                nl-NL
    -a----        10/4/2019   8:27 PM           2479 PSModule-Base-Config-Template.psd1
    -a----        10/6/2019   5:01 PM           2493 PSModule-Base.psd1
    -a----        10/6/2019   5:01 PM          16747 PSModule-Base.psm1

* File : PSModule-Base.psd1
    * The module manifest file.
* File : PSModule-Base.psm1
    * The module file is created by the *Build-Module* and is the concatenation of:
    * Prefix.ps1
        * As supplied in the *Build-Module* command '-prefix prefix.ps1'.
        * e.g. This locates and reads the config file.
    * All functions
        * All functions defined in the *private* and *public* folders.
    * Suffix.ps1
        * As supplied in the *Build-Module* command '-suffix suffix.ps1'.
        * e.g. Anything you want to do at the end of importing the module.
* File : PSModule-Base-Config-Template.psm1
    * x

<h1 id='import'>Import module</h1>

The module must be found in one of the standard module paths for *PowerShell* or *PowerShell Core*.

Since importing modules depends on your personal module tree and setup, in this README I use simple commands.
Personally I link PowerShell (folder WindowPowerShell and file Microsoft.PowerShell_profile.ps1) and PowerShell Core (folder PowerShell and file Profile.ps1) together.

    PS> Import-Module PSModule-Base

<h1 id='folderfiles'>Folders and files in this repo</h1>

In the root of the repo:

* File - CHANGELOG.md
    * This file.
    * Keep all modifcations in this file? That is all ps1, psd1, psm1, ...???
* File - README.md (this file)
    * Generic explanation of this module.
* File - LICENSE
    * Current module license.
    * GNU GENERAL PUBLIC LICENSE Version 3.

<h2 id="build">Build.ps1</h2>

<h2 id="prefix">Prefix.ps1</h2>

<h2 id="suffix">Suffix.ps1</h2>

<h2 id="suffix">PSModule-Base.psd1</h2>

<h2 id="suffix">PSModule-Base-Config-Template.psd1</h2>

<h2 id="suffix">PSModule-Base.[On, Off]</h2>

<h1 id='foldersource'>Folder - Source</h1>

<h2>Subfolder - en-US</h2>

A small English about.
Here some more work is required, maybe explain the way to work with multiple languages.

<h2>Subfolder - nl-NL</h2>

Een kleine Nederlandse uitleg.
Hier is meer werk noodzakelijk, misschien uitleggen hoe te werken met meerdere talen.

<h2>Folder - Sources</h2>

This folder contains the main files to create the final module.

* File - [Build.psd1](#build)
    * Configuration file for [ 'ModuleBuilder' ]( https://github.com/PoshCode/ModuleBuilder )
    * Trying to combine some suggested way's of working into my module.
* File - [Prefix.ps1](#prefix)
    * Used by ModuleBuilder.
    * The contents of this file will be put at the beginning of the created <module>.psm1 file containing all functions.
    * Here you can do some pre-requisite actions for your module. e.g.: Read a configuration file.
* File - [Suffix.ps1](#suffix)
    * Used by ModuleBuilder.
    * The contents of this file will be put at the end of the created <module>.psm1 file containing all functions.
    * Here you can do some cleanup or start something after the main part of your module is loaded.
* File - PSModule-Base.psd1
    * The manifest file for the module.
* File - PSModule-Base-Config.psd1
    * An example PowerShell configuration file for a module.

<h2>Subfolder - Private</h2>

<h2>Subfolder - Public</h2>

<h2>Subfolder - Tests</h2>

<h2>File - Build.psd1</h2>

<h2>File - Tools.psd1</h2>

<h1>Tested on</h1>

Operation System | PowerShell | PowerShell Core
-------------------------------------------------- | ---------- | ----------
Microsoft Windows 10 Home | 5.1 | 
