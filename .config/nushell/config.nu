$env.config = {
    show_banner: false
    hooks: {
        env_change: {
          PWD: [{ |before, after|
            if ('FNM_DIR' in $env) and ([.nvmrc .node-version] | path exists | any { |it| $it }) {
              fnm use
            }
          }]
        }
    }
}

const windows_home = "/mnt/c/Users/$(whoami)"
use ~/.cache/starship/init.nu
source ~/.zoxide.nu
alias fd = fdfind
alias bat = batcat
alias vim = nvim
alias gw = git worktree
alias oldvim = vim
alias windir = cd $windows_home
alias wez = vim "$windows_home/dotfiles/.config/wezterm/wezterm.lua"
alias ls = ls -a
alias rg = rg --smart-case --hidden --no-heading --column
