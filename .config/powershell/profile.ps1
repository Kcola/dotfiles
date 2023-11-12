# Tell starship where its config is:
$ENV:STARSHIP_CONFIG = "$HOME\dotfiles\.config\starship.toml"
$ENV:WEZTERM_CONFIG_FILE = "$HOME\dotfiles\.config\wezterm\wezterm.lua"
$ENV:NVIM_FULL = 'true'
# Start starship:
Invoke-Expression (&starship init powershell)

Set-Alias -Name s -Value save
Set-Alias -Name g -Value goto
Set-Alias -Name vim -Value nvim

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

function Update-FieldServiceBuild {
    try {
        $date = Get-Date -Format "yyMMdd"
        $output = "$env:TEMP\FieldService.$date"

        Start msedge "https://dev.azure.com/dynamicscrm/OneCRM/_build?definitionId=16035"
        Write-Host "Download latest 9.1 build in Artifacts and place in your downloads folder"
        Pause

        $package = GCI "$env:USERPROFILE/Downloads/FieldService.PdPackage*.zip" | Sort-Object LastWriteTime -Descending | Select-Object -First 1

        # Unzip
        Expand-Archive -Path $package.FullName -DestinationPath $output

        code "$output\FieldService.PdPackage\ImportConfig.xml"
        Write-Host "Make any changes to the config file and save"
        Pause

        # Repack
        $zip = "$env:USERPROFILE/Downloads/FieldService.PdPackage.$date.zip"
        Compress-Archive -Path $output\* -DestinationPath $zip -Force
        pac package deploy -p $zip
    }
    catch {
        Write-Error $_
    }
}
