# Portable-GitShell
Enabling the usage of [Posh-Git](http://github.com/dahlbyk/posh-git) and Git shell with a portable version of Git such as [PortableGit](http://github.com/git-for-windows/git/releases/) or the one contained into [Portable SmartGit](http://www.syntevo.com/smartgit/download)

### Manual start
`GIT_ROOT_FOLDER` is the folder containing the git folder (which in turn contains the bin folder) and the `New-GitShell.ps1` script, a GitHub for Windows shell.ps1 script, modified to be used with a portable version of Git:
```powershell
$gitRootFolder = 'GIT_DRIVE:\GIT_ROOT_FOLDER'
if (Test-Path $gitRootFolder)
{
    . (Resolve-Path "$gitRootFolder\New-GitShell.ps1")
}
```

### Automated start via a Windows shortcut
A Windows shortcut can be used to open PowerShell and enter the Git shell at the same time

The easiest way is to run `New-GitShell.ps1` directly (set the working folder using the shortcut "Start in" folder):
`C:\WINDOWS\system32\WindowsPowerShell\v1.0\powershell.exe -noexit -command "& 'GIT_DRIVE:\GIT_ROOT_FOLDER\New-GitShell.ps1'"`

If a custom behavior is needed, the above code can be put in an initialization script to be run from the shortcut:  
`C:\WINDOWS\system32\WindowsPowerShell\v1.0\powershell.exe -noexit -command "& 'SCRIPT_DRIVE:\SCRIPT_FOLDER\Init.ps1'"`

### Automated start via a PowerShell profile
The above code can be put in a PowerShell profile:  
`%UserProfile%\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1`

The WindowsPowerShell folder and the Microsoft.PowerShell_profile.ps1 file should be created if they do not exist.

### Remember credentials on push (clone is not suitable for configuration)
Install [Git Credential Manager for Windows](http://github.com/Microsoft/Git-Credential-Manager-for-Windows) by using the [latest ZIP installer](http://github.com/Microsoft/Git-Credential-Manager-for-Windows/releases/latest):
```bash
git-credential-manager install --path GIT_DRIVE:\GIT_ROOT_FOLDER\git
```

Add a Windows generic credential (Control Panel / Credential Manager)
```
Internet or network address
git:https://github.com

User name
yourUserName

Password
yourPasswordOrPersonalAccessToken
```

Configure Git credential helper
```bash
git config --global credential.helper manager
```

Remember to set repo credentials if different from the global ones
```bash
# Applies to all repos
git config --global user.name "Name Surname"
git config --global user.email "globalEmailAddress@server"

# Applies only to the repo from whose directory you launch the command
git config user.email "RepoEmailAddress@server"
```
