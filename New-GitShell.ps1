Push-Location (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)
$scriptPath = Get-Location

$env:portable_git = (Get-ChildItem -Path $scriptPath\git* | Where-Object { $_.PSIsContainer }).FullName
$env:PLINK_PROTOCOL = "ssh"
$env:TERM = "msys"
$env:HOME = Resolve-Path (Join-Path $env:HOMEDRIVE $env:HOMEPATH)
$env:TMP = $env:TEMP = [system.io.path]::gettemppath()
$msBuildPath = "$env:SystemRoot\Microsoft.NET\Framework\v4.0.30319"
$env:Path = "$env:Path;$env:HOME\bin;$env:portable_git\bin;$msbuildPath"

Set-Alias -Name git $env:portable_git\bin\git.exe

$poshGitFolder = "$scriptPath\poshGit"
if (!(Test-Path $poshGitFolder))
{
    New-Item -Path $poshGitFolder -ItemType Directory | Out-Null
    Start-Process -FilePath git -ArgumentList 'clone', 'https://github.com/dahlbyk/posh-git.git', "$poshGitFolder" -Wait -NoNewWindow
}
$env:posh_git = Resolve-Path $poshGitFolder
. $env:posh_git\profile.example.ps1

Register-EngineEvent -SourceIdentifier ([System.Management.Automation.PsEngineEvent]::Exiting) -Action { Stop-SshAgent } | Out-Null

Pop-Location