
<h1 id=top>Changelog for Module PSModule-Personal"</h1>

Started to use as many commonly used defaults to setup a Microsoft PowerShell module where changes and readme are part of.  
Help the PowerShell way is used for sure, but the community also uses some commonly used standards.  
Not sure yet, but maybe these files ( _CHANGELOG.md_ and _README.md_ ) will be small and point to the Microsoft PowerShell way of supplying help.

Links used as reference:

+ [Changelog at Wikipedia](https://en.wikipedia.org/wiki/Markdown)
+ [Changelog CommonMark Spec](http://spec.commonmark.org/)
+ [GitHub markdown based on CommonMark](https://github.github.com/gfm/)
+ [Pandoc - PowerShell module to convert 'Markdown' to ...](http://pandoc.org/)


---

<h1 id='history'>History</h1>

<h2 id='unrelease'>Unreleased</h2>

* Create and use *module-name.[On, Off]* file for 'write-host' usage because 'write-verbose' doesn't work during 'import-module'.

<h2>0.2.0</h2>

* *Added*
    * PSModule-Personal-Config.psd1
        * A PowerShell Configuration file for this module.
        * In my personal setup I (try to) have a configuration file in each module folder. Where possible I use a configuration file to define values instead of defining values in each script or function. This way function are less prone to errors.
    * Get-TimeStamp.ps1
        * Although in itself this is not to difficult it keeps me from defining a timestamp in every script. This function is in the first module I start so it can be used ASAP.
* *Modified*
    * PSModule-Personal.psd1
        * ModuleVersion = "0.2.0" : Because of config file.
    * Prefix.ps
        * Temporary modified 'write-verbose' to 'write-host'.
        The verbose of the module itself doesn't work during import.
        See [ Unrelease ]( #unrelease ).
        * Read the config file and add it to a $Global variable.

<h2>0.1.1 ( 2019-09-30 )</h2>

* _Added_
    * First setup of this CHANGELOG.md
* _Modified_
    * README.md


<h1 id='examples'>Examples of types of changes</h1>

- _Added_ : for new features.
- _Changed_ : for changes in existing functionality.
- _Deprecated_ : for (soon-to-be) removed features.
- _Removed_ : for now removed features.
- _Fixed_ : for any bug fixes.
- _Security_ : in case of vulnerabilities.