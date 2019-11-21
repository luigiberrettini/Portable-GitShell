Push-Location (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)
$scriptPath = Get-Location

$env:portable_git = (Get-ChildItem -Path $scriptPath\git* | Where-Object { $_.PSIsContainer }).FullName
$env:PLINK_PROTOCOL = "ssh"
$env:TERM = "msys"
$env:HOME = Resolve-Path $env:USERPROFILE
$env:TMP = $env:TEMP = [system.io.path]::gettemppath()
$env:Path = "$env:Path;$env:HOME\bin;$env:portable_git\bin"

Set-Alias -Name git $env:portable_git\bin\git.exe

$poshSshellFolder = "$scriptPath\poshSshell"
if (!(Test-Path $poshSshellFolder))
{
    New-Item -Path $poshSshellFolder -ItemType Directory | Out-Null
    Start-Process -FilePath git -ArgumentList 'clone', 'https://github.com/dahlbyk/posh-sshell.git', "$poshSshellFolder" -Wait -NoNewWindow
    $win32OpenSSHFile = "$poshSshellFolder\src\Win32-OpenSSH.ps1"
    ((Get-Content -Path $win32OpenSSHFile -Raw) -replace 'ssh.exe \|','ssh.exe -ErrorAction Ignore |') | Set-Content -Path $win32OpenSSHFile
}
Import-Module "$poshSshellFolder\posh-sshell.psm1"

$poshGitFolder = "$scriptPath\poshGit"
if (!(Test-Path $poshGitFolder))
{
    New-Item -Path $poshGitFolder -ItemType Directory | Out-Null
    Start-Process -FilePath git -ArgumentList 'clone', 'https://github.com/dahlbyk/posh-git.git', "$poshGitFolder" -Wait -NoNewWindow
}
Import-Module "$poshGitFolder\src\posh-git.psm1"

$openSshSvcName = 'ssh-agent'
$openSsh = Get-WmiObject Win32_Service | ? { $_.Name -eq $openSshSvcName }
if ($openSsh)
{
    if (Test-Path env:\SSH_AGENT_PID)
    {
        Remove-Item env:\SSH_AGENT_PID
    }
    if (Test-Path env:\SSH_AUTH_SOCK)
    {
        Remove-Item env:\SSH_AUTH_SOCK
    }
    while ($openSsh.StartMode -eq 'Disabled')
    {
        Start-Process -verb runAs 'cmd' "/c sc config ""$openSshSvcName"" start= demand"
        $openSsh = Get-WmiObject Win32_Service | ? { $_.Name -eq $openSshSvcName }
    }
}
Start-SshAgent -Quiet
Register-EngineEvent -SourceIdentifier ([System.Management.Automation.PsEngineEvent]::Exiting) -Action { Stop-SshAgent } | Out-Null

Pop-Location