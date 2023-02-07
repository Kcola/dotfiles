# Tell starship where its config is:
$ENV:STARSHIP_CONFIG = "$HOME\dotfiles\.config\starship.toml"
$ENV:WEZTERM_CONFIG_FILE = "$HOME\dotfiles\.config\wezterm\wezterm.lua"
$ENV:NVIM_FULL = 'true'
# Start starship:
Invoke-Expression (&starship init powershell)

Set-Alias -Name s -Value save
Set-Alias -Name g -Value goto
Set-Alias -Name vim -Value nvim

function Get-GitWorktree { & git worktree $args }

New-Alias -Name gw -Value Get-GitWorktree

function Get-GitStatus { & git status $args }
New-Alias -Name gs -Value Get-GitStatus

Import-Module PSReadLine

# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

Invoke-Expression (& {
    $hook = if ($PSVersionTable.PSVersion.Major -lt 6) { 'prompt' } else { 'pwd' }
    (zoxide init --hook $hook powershell | Out-String)
})
