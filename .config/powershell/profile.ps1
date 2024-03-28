# Tell starship where its config is:
if ($IsWindows){
$ENV:STARSHIP_CONFIG = "$HOME\dotfiles\.config\starship.toml"
$ENV:WEZTERM_CONFIG_FILE = "$HOME\dotfiles\.config\wezterm\wezterm.lua"
$ENV:NVIM_FULL = 'true'
}
if($IsMacOS){
Set-NodeVersion -Persist User 18
}
# Start starship:
Invoke-Expression (&starship init powershell)

Set-Alias -Name s -Value save
Set-Alias -Name g -Value goto
Set-Alias -Name vim -Value nvim

$env:Path += ";$HOME\.cargo\bin"

$ScriptsDIR = "$HOME\dotfiles\scripts"
function Get-GitWorktree { 
  if ($args -eq "clean"){
     & deno run -A "$ScriptsDIR\git-worktree.clean.ts" .  
  }
  else {
     & git worktree $args
  }
}

New-Alias -Name gw -Value Get-GitWorktree
New-Alias -Name gw-clean -Value Get-GitWorktree

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

function diffview {
    $env:NVIM_APPNAME="diffview"; nvim -c "DiffviewOpen"; $env:NVIM_APPNAME=$null
}

function start-cdb{
 & 'C:\Program Files\Azure Cosmos DB Emulator\CosmosDB.Emulator.exe' /port=11000 /NoExplorer
}

fnm env --use-on-cd | Out-String | Invoke-Expression

