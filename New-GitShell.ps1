Push-Location (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)
$scriptPath = Get-Location

$env:portable_git = (Get-ChildItem -Path "$scriptPath\git*" | Where-Object { $_.PSIsContainer }).FullName
$env:PLINK_PROTOCOL = 'ssh'
$env:TERM = 'msys'
$env:HOME = Resolve-Path $env:USERPROFILE
$env:TMP = $env:TEMP = [system.io.path]::gettemppath()
$env:Path = "$env:Path;$env:HOME\bin;$env:portable_git\bin"

Set-Alias -Name git "$env:portable_git\bin\git.exe"

$moduleNames = @('PSReadLine', 'posh-git', 'oh-my-posh')
foreach ($moduleName in $moduleNames)
{
    if (-not (Get-Module -ListAvailable -Name $moduleName))
    {
        Install-Module -Force -Repository PSGallery -Name $moduleName -Scope CurrentUser
    }
    Import-Module $moduleName
}
Set-PoshPrompt -Theme (Join-Path $scriptPath posh-prompt-theme-text.omp.json)

Pop-Location