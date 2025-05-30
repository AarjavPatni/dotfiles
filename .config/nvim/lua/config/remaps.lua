vim.keymap.set("n", ";", ":", { noremap = true })

local function bind(op, outer_opts)
    outer_opts = outer_opts or {noremap = true}
    return function(lhs, rhs, opts)
        opts = vim.tbl_extend("force",
            outer_opts,
            opts or {}
        )
        vim.keymap.set(op, lhs, rhs, opts)
    end
end

local nmap = bind("n", {noremap = false})
local imap = bind("i", {noremap = false})

local nnoremap  = bind("n")
local vnoremap  = bind("v")
local xnoremap  = bind("x")
local snoremap  = bind("s")
local inoremap  = bind("i")
local tnoremap  = bind("t")

vim.g.mapleader = " "
vim.g.maplocalleader = "m"

-- paste over highlight without losing stuff in d register
vim.keymap.set("x", "<leader>p", '"_dP')

-- make default dd and D delete without copying to register
vim.keymap.set("n", "dd", '"_dd')
vim.keymap.set("n", "D",  '"_D')
vim.keymap.set("x", "d",  '"_d')
vim.keymap.set("x", "D",  '"_D')

-- map leader versions to original functionality that copies to register
vim.keymap.set("n", "<leader>dd", "dd")
vim.keymap.set("n", "<leader>D",  "D")
vim.keymap.set("x", "<leader>d",  "d")
vim.keymap.set("x", "<leader>D",  "D")

-- map leader versions to original functionality that copies to register
vim.keymap.set("n", "<leader>y", '"+y')
vim.keymap.set("x", "<leader>y", '"+y')

-- CodeCompanion
vim.keymap.set({ "n", "v" }, "<C-a>", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<leader>a", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
vim.keymap.set("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })

vim.cmd([[cab cc CodeCompanion]])
vim.cmd([[cab nhl nohlsearch]])

-- search dotfiles
nnoremap("<leader>f.", function()
    require('plugins.telescope').search_dotfiles()
end)

-- global autoindent
vim.keymap.set("n", "==", "gg=G<C-o>")

-- search files
nnoremap("<leader>/", ":Telescope frecency workspace=CWD <CR>")
nnoremap("<leader>fg", ":Telescope live_grep <CR>")
nnoremap("<leader>fs", ":AerialNavOpen <CR>")
nnoremap("<leader>fS", ":Telescope lsp_workspace_symbols<CR>")

-- open telescope
nnoremap("<leader>t", ":Telescope <CR>")

-- Reload init.lua
nnoremap("<leader>so", ":so ~/.config/nvim/init.lua")

-- snippets
vim.cmd [[
    imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>' 
    inoremap <silent> <S-Tab> <cmd>lua require'luasnip'.jump(-1)<Cr>
    
    snoremap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>' 
    snoremap <silent> <S-Tab> <cmd>lua require('luasnip').jump(-1)<Cr>
]]

-- Emacs key mapping in insert mode; haha evil
imap("<C-a>", "<Home>")
imap("<C-e>", "<End>")
imap("<C-b>", "<ESC>bi")
imap("<C-f>", "<ESC>wa")
imap("<C-n>", "<ESC>ja")
imap("<C-p>", "<ESC>ka")

-- Debugging
nnoremap("<leader>dap", ":lua require'dap'.continue() <CR>")
nnoremap("<leader>db", ":lua require'dap'.toggle_breakpoint() <CR>")
nnoremap("<leader>dB", ":lua require'dap'.set_breakpoint() <CR>")
nnoremap("<leader>dn", ":lua require'dap'.step_over() <CR>")
nnoremap("<leader>di", ":lua require'dap'.step_into() <CR>")
nnoremap("<leader>dr", ":lua require'dap'.repl_open() <CR>")

tnoremap("<ESC>", "<C-\\><C-n>")

-- Create a custom command :ww that saves and formats Elixir files
vim.api.nvim_create_user_command("WW", function()
  -- Save the file first
  vim.cmd("write")
  
  -- Only run formatter on Elixir files
  local filename = vim.fn.expand("%")
  if filename:match("%.ex$") or filename:match("%.exs$") then
    local view = vim.fn.winsaveview()
    
    -- Run mix format asynchronously
    vim.fn.jobstart("mix format " .. vim.fn.shellescape(filename), {
      on_exit = function(_, exit_code)
        if exit_code == 0 then
          vim.schedule(function()
            if vim.api.nvim_buf_is_valid(vim.fn.bufnr(filename)) then
              -- Reload file content
              vim.cmd("checktime " .. vim.fn.bufnr(filename))
              -- Restore cursor position
              vim.fn.winrestview(view)
              -- Join with previous undo block
              pcall(function() vim.cmd("undojoin") end)
            end
          end)
        end
      end
    })
  end
end, {})
