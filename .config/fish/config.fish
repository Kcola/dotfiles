set windows_home "/mnt/c/Users/(whoami)"
if status is-interactive
  zoxide init fish | source
  fish_default_key_bindings
  alias fd="fdfind"
  alias bat="batcat"
  alias vim="nvim"
  alias gw="git worktree"
  alias oldvim="vim"
  alias windir="cd $windows_home"
  alias wez="vim $windows_home/dotfiles/.config/wezterm/wezterm.lua"
  alias ls="ls -a"
  alias 'rg'='rg --smart-case --hidden --no-heading --column'
  alias clear "TERM=xterm /usr/bin/clear"
  source ~/.fishmarks/marks.fish
  starship init fish | source
end

export NVM_DIR="$HOME/.nvm"
