vim.opt.backup = false -- creates a backup file
vim.opt.clipboard = "unnamedplus" -- allows neovim to access the system clipboard
vim.opt.cmdheight = 1 -- more space in the neovim command line for displaying messages
vim.opt.completeopt = { "menuone", "noselect" } -- mostly just for cmp
vim.opt.conceallevel = 0 -- so that `` is visible in markdown files
vim.opt.fileencoding = "utf-8" -- the encoding written to a file
vim.opt.hlsearch = false -- highlight all matches on previous search pattern
vim.opt.ignorecase = true -- ignore case in search patterns
vim.opt.mouse = "a" -- allow the mouse to be used in neovim
vim.opt.pumheight = 10 -- pop up menu height
vim.opt.showmode = false -- we don't need to see things like -- INSERT -- anymore
vim.opt.showtabline = 2 -- always show tabs
vim.opt.smartcase = true -- smart case
vim.opt.smartindent = true -- make indenting smarter again
vim.opt.splitbelow = true -- force all horizontal splits to go below current window
vim.opt.splitright = true -- force all vertical splits to go to the right of current window
vim.opt.swapfile = false -- creates a swapfile
vim.opt.timeoutlen = 1000 -- time to wait for a mapped sequence to complete (in milliseconds)
vim.opt.updatetime = 300 -- faster completion (4000ms default)
vim.opt.writebackup = false -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
vim.opt.expandtab = true -- convert tabs to spaces
vim.opt.shiftwidth = 2 -- the number of spaces inserted for each indentation
vim.opt.tabstop = 2 -- insert 2 spaces for a tab
vim.opt.cursorline = true -- highlight the current line
vim.opt.number = true -- set numbered lines
vim.opt.relativenumber = false -- set relative numbered lines
vim.opt.numberwidth = 4 -- set number column width to 2 {default 4}
vim.opt.signcolumn = "yes" -- always show the sign column, otherwise it would shift the text each time
vim.opt.wrap = false -- display lines as one long line
vim.opt.scrolloff = 8 -- is one of my fav
vim.opt.termguicolors = true
vim.opt.sidescrolloff = 8
vim.opt.incsearch = true
vim.opt.guifont = "monospace:h17" -- shell
vim.opt.hidden = true
vim.opt.shortmess:append("c")
vim.opt.laststatus = 3

vim.cmd("let g:tablineclosebutton=1")

vim.cmd("set whichwrap+=<,>,[,],h,l")
vim.cmd([[set iskeyword+=-]])
vim.cmd([[set noequalalways]])

-- vim.g.gruvbox_contrast_dark = "hard"
vim.cmd([[colorscheme codedark]])
vim.cmd("hi Normal ctermbg=NONE guibg=NONE")
vim.cmd("hi CursorLineNr  guibg=NONE")
vim.cmd("hi EndOfBuffer  guibg=NONE")
vim.cmd("hi Folded  guibg=NONE")
vim.cmd("hi LineNr ctermbg=NONE guibg=NONE")
vim.cmd("hi SignColumn ctermbg=NONE guibg=NONE")
vim.g.rainbow_active = 1
vim.g.airline_powerline_fonts = 1
vim.cmd(":autocmd FileType qf nnoremap <buffer> <CR> <CR>:cclose<CR>")
vim.cmd(":autocmd FileType qf nnoremap <buffer> <Esc> <CR>:cclose<CR>")
vim.cmd("command! Cnext try | cnext | catch | cfirst | catch | endtry")
vim.cmd("command! Cprev try | cprev | catch | clast | catch | endtry")
vim.cmd(":autocmd FileType qf nnoremap <buffer> <Tab> <CR>:Cnext<CR><C-W><C-P>")
vim.cmd(":autocmd FileType qf nnoremap <buffer> <S Tab> <CR>:Cprev<CR><C-W><C-P>")

require("neoscroll").setup()
