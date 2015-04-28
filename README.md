# Portable-GitShell
[Posh-Git](http://github.com/dahlbyk/posh-git "Posh-Git") and Git shell with a portable version of Git

### Manual start
```powershell
$gitRootFolder = 'GIT_DRIVE:\GIT_ROOT_FOLDER'
if (Test-Path $gitRootFolder)
{
    . (Resolve-Path "$gitRootFolder\New-GitShell.ps1")
}
```


### Automated start via a Windows shortcut
The above code can be put in an initialization script so that a Windows shortcut can be used to open PowerShell and enter the Git shell at the same time:

`C:\WINDOWS\system32\WindowsPowerShell\v1.0\powershell.exe -noexit -command "& 'INIT_SCRIPT_DRIVE:\INIT_SCRIPT_FOLDER\Init.ps1'"`


### Automated start via a PowerShell profile
The above code can be put in a PowerShell profile:

`%UserProfile%\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1`

The WindowsPowerShell folder and the Microsoft.PowerShell_profile.ps1 file should be created if they do not exist.
