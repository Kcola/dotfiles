$PowershellProfileDirectory = "$HOME\Documents\pwsh"

if (-not (Test-Path $PowershellProfileDirectory)) {
    New-Item -ItemType Directory -Path $PowershellProfileDirectory
}

"`$PROFILE = '$HOME\dotfiles\.config\powershell\profile.ps1'
. `$PROFILE" | Out-File -FilePath "$HOME\Documents\pwsh\Microsoft.PowerShell_profile.ps1" -Encoding UTF8
