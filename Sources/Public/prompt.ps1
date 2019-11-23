# Setup a prompt
function Prompt { # Function Begin : Setup a prompt
    # Show folder and it count of files in the window title.
    $host.ui.rawui.WindowTitle = 'Folder : ' + ( get-location ) + ' - Files: ' + ( get-childitem ).count
  
    # Check if current user is an 'Administrator'. Returns True or False.
    $Identity = [ Security.Principal.WindowsIdentity ]::GetCurrent()
    $Principal = [ Security.Principal.WindowsPrincipal ] $identity
    $Global:IsAdmin = $Principal.IsInRole([ Security.Principal.WindowsBuiltInRole ] "Administrator" )
  
    # Set some prompt variables and print 1st part.
    $PromptPostfix = ' >'
    $PromptProps = @{ }
    Write-Host "PS " -NoNewline
  
    # Set 2nd part of prompt depending if 'Administrator' or not.
    if ( $IsAdmin ) {
      $PromptPrefix = '[Admin]'
  
      # If at console show some color if 'Administrator'.
      if ( $host.Name -eq 'ConsoleHost' ) {
        $PromptProps += @{
          ForegroundColor = 'Red'
        }
      }
    }
    else {
      $PromptPrefix = '[Normal]'
    }
  
    # Write the PreFix with colors if available.
    Write-Host $PromptPrefix @PromptProps -NoNewline
  
    # Write the PostFix and return.
    Write-Host $PromptPostfix -NoNewline
    return " "
  }
  # Function End : Setup a prompt
  