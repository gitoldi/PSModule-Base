
# Changelog for Module PSModule.Base"

Started to use as many commonly used defaults to setup a Microsoft PowerShell module where changes and readme are part of.  
Help the PowerShell way is used for sure, but the community also uses some commonly used standards.  
Not sure yet, but maybe these files ( _CHANGELOG.md_ and _README.md_ ) will be small and point to the Microsoft PowerShell way of supplying help.

Links used as reference:

+ [Changelog at Wikipedia](https://en.wikipedia.org/wiki/Markdown)
+ [Changelog CommonMark Spec](http://spec.commonmark.org/)
+ [GitHub markdown based on CommonMark](https://github.github.com/gfm/)
+ [Pandoc - PowerShell module to convert 'Markdown' to ...](http://pandoc.org/)

---

## History

### Unreleased

+ Create and use *module-name.[On, Off]* file for 'write-host' usage because 'write-verbose' doesn't work during 'import-module'.

### 0.4.0 - 210706

+ _Modified_
  + CHANGELOG.md - Modified all inline HTML to VSC MD validation.
  + README.md - Modified all inline HTML to VSC MD validation.
+ _Renamed_
  + Renamed all 'PSModule-Base' to 'PSModule.Base'.

### 0.3.5 - 210706

+ _Added_
  + Invoke-TSPingSweep.ps1

### 0.3.4 - 210209

+ _Modified_
  + Show-ModulePath.ps1
    + Added Parameter 'Version'.
  + Test-WriteProgress.psd1
    + Added Parameter 'Version'.

### 0.3.3 - 210127

Some old modifications on home system that require merge first before i can continue.

+ _Added_
  + PSModule.Base.Off.psd1
+ _Modified_
  + Prefix.ps1
  + PSModule.Base.psd1
+ _Renamed_
  + PSModule.Base-Config-Template.psd1 -> Config-PSModule.Base-Template.psd1
+ _Removed_
  + PSModule.Base.Off

### 0.3.2 - 210127

Pester tests created at the office.

+ *Added*
  + Convert-Bytes.Test.ps1
    + Pester-Convert-Bytes-210127
  + Get-TimeStamp.Test.ps1
    + Pester-Get-TimeStamp-210127

### 0.3.1 - 200807

+ *Added*
  + Test and create folders from configuration.
  + Create variables for the __existing__ folders.

### 0.3.0 - 200414

+ *Modified*
  + Renamed from *PSModule-Personal* to *PSModule.Base*.

### 0.2.9 - 200213

+ *Modified*
  + Moved the module to OneDrive instead of userprofile.

### 0.2.8 - 191129

+ *Modified*
  + Get-Software.ps1
    + Added an object per path for unknown/empty key's.

### 0.2.7 - 191128

+ *Added*
  + Get-Software.ps1
    + Used source: [Gathering Installed Software Using PowerShell](https://mcpmag.com/articles/2017/07/27/gathering-installed-software-using-powershell.aspx) on MCPMAG.
      + Some tweaking to conform to my personal setup.

### 0.2.6 - 191126d

+ *Added*
  + Show-Characterline.ps1
    + Display a line with numbers to show in a terminal as indicator for the width.
    + Default is 80 characters, but use parameter 'MaxLoop' for other numbers.
    + Show-Characterline -MaxLoop 32
      + 012345678901234567890123456789012
    + Returns this string too so if required the total string can be used elsewere.

### 0.2.5 - 191124

+ *Added*
  + Get-Calendar.ps1
    + Something from the internet.
    + A PowerShell way for the *ix 'cal' command.

### 0.2.4 - 191123

+ *Added*
  + Prompt.ps1
    + Copied from my previous personal named module.
    + Changes the prompt. e.g. a red '[Admin]' when the prompt is run as administrator.
  + Test-WriteProgress
    + Copied from my previous personal named module.
    + Multi level demo of progress bars.

### 0.2.3 - 191123

+ *Added*
  + Convert-Bytes : Moved from my previous personal named module.
+ *Modified*
  + Changed version in 'PSModule-Personal.psd1'.

### 0.2.2

+ *Added*
  + Show-Popup.ps1
    + A(nother) wrapper around a Windows popup.
    + This will show a Windows popup with (a) button(s).
    + But in addition it will return a custom object so you can use the return to continue your flow.

### 0.2.1

+ *Added*
  + Get-CommandVersion.ps1
    + The 'Get-Command' showd the version of the module itself. Not of the functions/commands in the module.
    + This function will show the version of the functions within a module.
+ *Modified*
  + Get-TimeStamp

### 0.2.0

+ *Added*
  + PSModule-Personal-Config.psd1
    + A PowerShell Configuration file for this module.
    + In my personal setup I (try to) have a configuration file in each module folder. Where possible I use a configuration file to define values instead of defining values in each script or function. This way function are less prone to errors.
  + Get-TimeStamp.ps1
    + Although in itself this is not to difficult it keeps me from defining a timestamp in every script. This function is in the first module I start so it can be used ASAP.
+ *Modified*
  + PSModule-Personal.psd1
    + ModuleVersion = "0.2.0" : Because of config file.
  + Prefix.ps
    + Temporary modified 'write-verbose' to 'write-host'. The verbose of the module itself doesn't work during import. See [Unrelease](#unrelease).
    + Read the config file and add it to a $Global variable.

### 0.1.1 ( 2019-09-30 )

+ _Added_
  + First setup of this CHANGELOG.md
+ _Modified_
  + README.md

## Examples of types of changes

+ _Added_ : for new features.
+ _Changed_ : for changes in existing functionality.
+ _Deprecated_ : for (soon-to-be) removed features.
+ _Removed_ : for now removed features.
+ _Fixed_ : for any bug fixes.
+ _Security_ : in case of vulnerabilities.
