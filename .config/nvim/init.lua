-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- load last session
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		vim.defer_fn(function()
			require("persistence").load()
		end, 1)
	end,
})

-- load SnipMate for LuaSnip
require("luasnip.loaders.from_snipmate").lazy_load()

-- Keymaps
vim.keymap.set("n", ";", ":", { noremap = true })
