-- Reopen file in last closed position
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = { "*" },
  callback = function()
    local last_pos = vim.fn.line([['"]])
    if last_pos > 1 and last_pos <= vim.fn.line("$") then
      vim.api.nvim_exec('normal! g`"', false)
    end
  end,
})

vim.opt.termguicolors 	= true
vim.opt.encoding 	= "utf-8"
vim.opt.syntax="on"

vim.opt.scrolloff  = 15
vim.opt.sidescroll = 10

vim.opt.belloff 	= "all"

vim.opt.incsearch	= true
vim.opt.hlsearch 	= true

vim.opt.foldmethod	= "manual"
vim.opt.wrap 		= false
-- wrap in quickfix list
vim.cmd([[
  augroup quickfix
    autocmd!
    autocmd FileType qf setlocal wrap
  augroup END
]])

vim.opt.textwidth 	= 90
vim.opt.completeopt	={"menu","menuone","noselect","noinsert","preview"}

vim.opt.splitbelow	= true
vim.opt.splitright	= true

vim.opt.background = "light"

vim.opt.nu	= true
vim.opt.rnu	= true

vim.opt.linespace = 5
vim.opt.cmdheight = 1

vim.opt.cocu = "n"
vim.opt.cole = 0

vim.opt.timeoutlen = 500

vim.opt.textwidth=100
vim.opt.shortmess:append("c")
vim.opt.fileformat="unix"

vim.opt.cursorline=true
vim.opt.cursorcolumn=true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.cindent=true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.shell="/bin/zsh"

vim.api.nvim_create_autocmd("TermOpen", {
  command = "setlocal nonumber norelativenumber"
})
