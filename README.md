# Portable-GitShell
Enabling the usage of [Posh-Git](http://github.com/dahlbyk/posh-git) and Git shell with a portable version of Git such as [PortableGit](http://github.com/msysgit/msysgit/releases) or the one contained into [Portable SmartGit](http://www.syntevo.com/smartgit/download)

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
The above code can be put in an initialization script so that a Windows shortcut can be used to open PowerShell and enter the Git shell at the same time:  
`C:\WINDOWS\system32\WindowsPowerShell\v1.0\powershell.exe -noexit -command "& 'SCRIPT_DRIVE:\SCRIPT_FOLDER\Init.ps1'"`

### Automated start via a PowerShell profile
The above code can be put in a PowerShell profile:  
`%UserProfile%\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1`

The WindowsPowerShell folder and the Microsoft.PowerShell_profile.ps1 file should be created if they do not exist.

### Remember credentials on push
Install [Windows Credential Store for Git](http://gitcredentialstore.codeplex.com):  
`git-credential-winstore -i GIT_DRIVE:\GIT_ROOT_FOLDER\git\bin\Git.exe`
