# Tell starship where its config is:
$ENV:STARSHIP_CONFIG = "$HOME\dotfiles\.config\starship.toml"
$ENV:WEZTERM_CONFIG_FILE = "$HOME\dotfiles\.config\wezterm\wezterm.lua"
$ENV:NVIM_FULL = 'true'
# Start starship:
Invoke-Expression (&starship init powershell)

Set-Alias -Name s -Value save
Set-Alias -Name g -Value goto

function Get-GitWorktree { & git worktree $args }

New-Alias -Name gw -Value Get-GitWorktree

function Get-GitStatus { & git status $args }
New-Alias -Name gs -Value Get-GitStatus

Import-Module PSReadLine
Import-Module z
