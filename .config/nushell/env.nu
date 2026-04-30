# Nushell Environment Config File
#
# version = "0.97.1"

$env.PATH = ($env.PATH | split row (char esep) | prepend '/home/linuxbrew/.linuxbrew/bin')
$env.PATH = ($env.PATH | split row (char esep) | prepend '~/.cargo/bin/')
$env.PATH = ($env.PATH | split row (char esep) | prepend '/opt/homebrew/bin')
$env.PATH = ($env.PATH | split row (char esep) | prepend '/usr/local/bin/')
$env.PATH = ($env.PATH | split row (char esep) | prepend '~/.local/bin')
$env.PATH = ($env.PATH | split row (char esep) | prepend '~/.dotnet/tools/')
$env.PATH = ($env.PATH | split row (char esep) | prepend '~/Library/Application Support/JetBrains/Toolbox/scripts')
$env.PATH = ($env.PATH | split row (char esep) | prepend '~/.config/agency/CurrentVersion/')

mkdir ~/.cache/starship
starship init nu | save -f ~/.cache/starship/init.nu
zoxide init nushell | save -f ~/.zoxide.nu

# File: config.nu
use std "path add"
if not (which fnm | is-empty) {
  ^fnm env --json | from json | load-env
  let node_path = match $nu.os-info.name {
    "windows" => $"($env.FNM_MULTISHELL_PATH)",
    _ => $"($env.FNM_MULTISHELL_PATH)/bin",
  }
  path add $node_path
}

# pnpm
$env.PNPM_HOME = if (sys host | get name) == "Darwin" {
  $"($env.HOME)/Library/pnpm"
} else {
  $"($env.HOME)/.local/share/pnpm"
}
$env.PATH = ($env.PATH | split row (char esep) | prepend $env.PNPM_HOME )
# pnpm end

# Source private env vars (not tracked by yadm)
source ~/.config/nushell/env.private.nu

# Default browser (use wslview to open URLs in Windows default browser)
$env.BROWSER = "wslview"
