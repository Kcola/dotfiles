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

def get_commits [filePath:string] {
  # get file content
  let strings = open $filePath | lines | str replace "!" ""

  # filter git log comparing each entry to a line from the above file
  let log = git log -n 1000 --pretty=format:"%H|%aD|%s" | lines
  | split column "|" hash time message 
  | where { |entry| $strings | any { |str| $entry.message =~ $str } } 
  | upsert time { |d| $d.time | into datetime } | reverse

  print $log

  let hashes = $log | get hash | str join ' '
  print $"git cherry-pick ($hashes)"
}
