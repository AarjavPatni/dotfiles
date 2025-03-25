if not vim.g.vscode then
  require("config.sets")
  require("config.lazy")
  require('config.remaps')
  require('config.netrw')
  require('plugins.lspconfig')
  require('plugins.nvim-cmp')
  require('plugins.treesitter')
  require('plugins.lualine')
  --require("plugins")
end
