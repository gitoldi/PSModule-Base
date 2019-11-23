function Show-Popup {
    <#
    .SYNOPSIS
    Show Windows popup.

    .DESCRIPTION
    Show Windows popup.
    A(nother) wrapper around Windows popup.
    But this one returns a custom object in the idea of Don Jones : don't kill the puppies.

    Some sources used:
    https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_switch?view=powershell-6
    https://docs.microsoft.com/en-us/previous-versions/windows/internet-explorer/ie-developer/windows-scripting/x83z1d9f(v=vs.84)?redirectedfrom=MSDN
    https://powershell.org/2013/04/powershell-popup/
    https://4sysops.com/archives/how-to-display-a-pop-up-message-box-with-powershell/

    .PARAMETER Version
    Will show the version of the script and exit.

    .PARAMETER PopupText
    Supply this parameter and text that should be displayed in the box.

    .PARAMETER PopupTitle
    Supply this parameter and text that should be displayed in the title bar of the box.

    .PARAMETER PopupDisplaySeconds
    Supply this parameter and an integer that is the amount of seconds the box should be shown.
    When this time expires the box will be closed automatically.
    Default the box will be displayed until a button is clicked.

    .PARAMETER PopupButton
    Supply this parameter and a text with the requested buttons.
    Available button options are: "OK", "OKCancel", "AbortRetryIgnore", "YesNoCancel", "YesNo",
    "RetryCancel", "CancelTryAgainContinue"
    Default button is "OK".

    .PARAMETER PopupIcon
    Supply this parameter and text with the requested icon type.
    Available icons are: "Error", "Question", "Warning", "Information"
    Default icon is "Information".

    .INPUTS
    The defined parameters.

    .OUTPUTS
    NA.

    .NOTES
    History:

    191109 MR
    - 0.9.0 Created.

    .EXAMPLE
    PS C:\>  Show-Popup 'This is a test.'

    The shortest way to call the script is even without any text.
    But this is the simplest and shortest way. Just supply your text. All other parameters have defaults.
    This will show a popup with default title 'Popup title', 'informational' icon, 'OK' button.
    The popup will stay until the button is clicked.
    After the button is clicked the custom object information is shown.
    
    Button      : OK
    ButtonValue : 0
    Icon        : Information
    IconValue   : 64
    ReturnCode  : 1
    ReturnText  : OK button
    Seconds     : 0
    Text        : This is a test.
    Title       : Popup Title.

    .EXAMPLE
    PS C:\> $Popupdata = Show-Popup -Verbose -PopupText 'Select one of the buttons.' -PopupTitle 'Make a choice.' -PopupDisplaySeconds 5 -PopupButton YesNoCancel -PopupIcon Warning

    This will show a popup with title 'Make a choice', Text 'Select one of the buttons',
    'Warning' icon, 'YesNoCancel' button. The popup will close automatically after 5 seconds.
    All information is returned into the variable : $Popupdata
    Data can be accessed using : $Popupdata.<attribute>
    e.g. $Popup.ReturnCode will return 6 when 'Yes' was selected.
    The $Popupdata contains the following attributes and values:

    - When closed automatically:
    Button      : YesNoCancel
    ButtonValue : 3
    Icon        : Warning
    IconValue   : 48
    ReturnCode  : -1
    ReturnText  : The user did not click a button before nSecondsToWait seconds elapsed.
    Seconds     : 5
    Text        : Select one of the buttons.
    Title       : Make a choice.

    - When selected 'Yes' (same as above, but changed values):
    ReturnCode  : 6
    ReturnText  : Yes button

    - When selected 'No' (same as above, but changed values):
    ReturnCode  : 7
    ReturnText  : No button

    - When selected 'Cancel' (same as above, but changed values):
    ReturnCode  : 2
    ReturnText  : Cancel button

    #>

    #Requires -Version 5.1
    #Requires -PSEdition Core, Desktop

    #Region 'Initialize.'
    [ CmdletBinding( )]

    param (
        [ Parameter( )]
        [ Switch ] $Version
        ,
        [ Parameter(
            Position = 0,
            HelpMessage = 'Enter a message text.'
        )]
        [ ValidateNotNullorEmpty( )]
        [ string ] $PopupText = 'Do you want to do continue?'
        ,
        [ Parameter(
            HelpMessage = "Enter a title for the popup."
        )]
        [ ValidateNotNullorEmpty( )]
        [ string ] $PopupTitle = 'Popup Title.'
        ,
        [ Parameter(
            HelpMessage = 'How many seconds should the popup show. Default: displays until click.'
        )]
        [ ValidateScript({ $_ -ge 0 })]
        [ int16 ] $PopupDisplaySeconds = 0
        ,
        [ Parameter(
            HelpMessage = 'Select a button (group). Default: OK.'
        )]
        [ ValidateNotNullorEmpty()]
        [ ValidateSet(
            "AbortRetryIgnore",
            "CancelTryAgainContinue",
            "OK",
            "OKCancel",
            "RetryCancel",
            "YesNoCancel",
            "YesNo"
        )]
        [ string ] $PopupButton = "OK"
        ,
        [ Parameter(
            HelpMessage = "Enter an icon. Default: Information."
        )]
        [ ValidateNotNullorEmpty( )]
        [ ValidateSet( "Error", "Information", "Question", "Warning" )]
        [ string ] $PopupIcon = "Information"
    )
    #EndRegion 'Initialize.'

    #Region 'First get name and return version if requested.'
    $ScriptName = [io.path]::GetFileNameWithoutExtension( $MyInvocation.MyCommand.Name ) + '(F)'
    [ version ] $ScriptVersion = '0.9.0'
    Write-Verbose "$( Get-TimeStamp ) $( $ScriptName ) INFO Test if Version was requested: $( $ScriptVersion )"
    if ( $Version ) {
        Write-Verbose "$ScriptName version : $ScriptVersion"
        Return $ScriptVersion
    }
    #EndRegion 'First get name and return version if requested.'

    #Region 'Define script specific variables.'
    Write-Verbose "$( Get-TimeStamp ) $( $ScriptName ) INFO Set script specific variables."
    #EndRegion 'Define script specific variables.'

    #Region 'Translate the selected button text into a value.'
    Write-Verbose "$( Get-TimeStamp ) $( $ScriptName ) INFO Translate button text to value for the object."
    Switch ( $PopupButton ) {
        "OK"                        { $PopupValue = 0 }
        "OKCancel"                  { $PopupValue = 1 }
        "AbortRetryIgnore"          { $PopupValue = 2 }
        "YesNoCancel"               { $PopupValue = 3 }
        "YesNo"                     { $PopupValue = 4 }
        "RetryCancel"               { $PopupValue = 5 }
        "CancelTryAgainContinue"    { $PopupValue = 6 }
    }
    #EndRegion 'Translate the selected button text into a value.'

    #Region 'Translate the selected icon text into a value.'
    Write-Verbose "$( Get-TimeStamp ) $( $ScriptName ) INFO Translate icon text to value for the object."
    Switch ( $PopupIcon ) {
        "Error"         { $IconValue = 16 }
        "Question"      { $IconValue = 32 }
        "Warning"       { $IconValue = 48 }
        "Information"   { $IconValue = 64 }
    }
    #EndRegion 'Translate the selected icon text into a value.'

    #Region 'Try to create the object and display the popup.'
    try {
        #Region 'Create object, show popup and save returncode.'
        Write-Verbose "$( Get-TimeStamp ) $( $ScriptName ) INFO Create the object."
        $wshell = New-Object -ComObject Wscript.Shell
        Write-Verbose "$( Get-TimeStamp ) $( $ScriptName ) INFO Create popup and save return value."
        $ReturnCode = $wshell.Popup(
            $PopupText,
            $PopupDisplaySeconds,
            $PopupTitle,
            $PopupValue + $IconValue
        )
        #EndRegion 'Create object, show popup and save returncode.'

        #Region 'Translate return code to return text.'
        Write-Verbose "$( Get-TimeStamp ) $( $ScriptName ) INFO Translate return code to readable text."
        switch ( $ReturnCode ) {
            -1	{ $ReturnText = 'The user did not click a button before nSecondsToWait seconds elapsed.' }
            1	{ $ReturnText = 'OK button' }
            2	{ $ReturnText = 'Cancel button' }
            3	{ $ReturnText = 'Abort button' }
            4	{ $ReturnText = 'Retry button' }
            5	{ $ReturnText = 'Ignore button' }
            6	{ $ReturnText = 'Yes button' }
            7	{ $ReturnText = 'No button' }
            10	{ $ReturnText = 'Try Again button' }
            11	{ $ReturnText = 'Continue button' }
            Default { $ReturnText = 'Unknown code' }
        }
        #EndRegion 'Translate return code to return text.'

        #Region 'Create custom object.'
        Write-Verbose "$( Get-TimeStamp ) $( $ScriptName ) INFO Create custom object to enable continuation."
        [ PSCustomObject ] @{
            Button = $PopupButton
            ButtonValue = $PopupValue
            Icon = $PopupIcon
            IconValue = $IconValue
            ReturnCode = $ReturnCode
            ReturnText = $ReturnText
            Seconds = $PopupDisplaySeconds
            Text = $PopupText
            Title = $PopupTitle
        }
        #EndRegion 'Create custom object.'
    }
    catch {
        #Region 'Creating object or showing popup failed.'
        Write-Warning "$ScriptName ERROR Failed to create Wscript.Shell COM object"
        Write-Warning $_.exception.message
        #EndRegion 'Creating object or showing popup failed.'
    }
    #EndRegion 'Try to create the object and display the popup.'
}
