-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

---
require('lazy').setup({

    {
        "rebelot/kanagawa.nvim",
        config = function()
            vim.cmd.colorscheme('kanagawa')
        end,
    },

    --({
    --    'rose-pine/neovim',
    --    name = 'rose-pine',
    --    config = function ()
    --      vim.cmd [[colorscheme rose-pine-moon]]
    --    end
    --}),

    {
        'lukas-reineke/indent-blankline.nvim',
        config = function () require("ibl").setup({
            indent = {char = "·" },
            scope = { enabled = false },
        }
        ) end
    },

    {
        'norcalli/nvim-colorizer.lua',
        config = function() require'colorizer'.setup() end,
    },

    {
        'winston0410/range-highlight.nvim',
        dependencies = {'winston0410/cmd-parser.nvim'},
        config = function() require'range-highlight'.setup() end,
    },

    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'kyazdani42/nvim-web-devicons', lazy = true },
        config = function() require('lualine').setup() end,
    },

    -- nice utils
    'folke/which-key.nvim',
    {
        'windwp/nvim-autopairs',
        config = function() require('nvim-autopairs').setup() end,
    },

    -- lodash basically
    {
        'nvim-telescope/telescope.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-lua/popup.nvim',
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
            { 'nvim-telescope/telescope-frecency.nvim' }
        },
        config = function()
            require('telescope').setup({
                defaults = {
                    file_ignore_patterns = { "node_modules", ".git/" },
                },
                pickers = {
                    find_files = {
                        hidden = true
                    }
                },
                extensions = {
                    frecency = {
                        ignore_patterns = {"*.git/*", "*/tmp/*"},
                    }
                }
            })
            require('telescope').load_extension('fzf')
            require('telescope').load_extension('frecency')
        end,
        version = '0.1.6'
    },

    { 'nvim-treesitter/nvim-treesitter', build=':TSUpdate' },
    'nvim-treesitter/nvim-treesitter-context',
    {
        'nvim-treesitter/nvim-treesitter-textobjects',
        dependencies = 'nvim-treesitter/nvim-treesitter'
    },
    {
        'stevearc/aerial.nvim',
        opts = {},
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons"
        },
        config = function() require("aerial").setup({
            on_attach = function(bufnr)
                vim.keymap.set("n", "<leader>ss", "<cmd>AerialNavOpen<CR>", { buffer = bufnr })
            end,
        })
        end
    },

    -- git
    {
        'lewis6991/gitsigns.nvim',
        config = function() require('gitsigns').setup() end,
    },

    {
        'tpope/vim-fugitive'
    },

    -- Interactive Reply Over Nvim
    {
        'jpalardy/vim-slime',
        config = function()
            vim.g.slime_target = "tmux"
            vim.g.slime_default_config = {
                socket_name = "default",
                target_pane = "0"
            }
            vim.g.slime_dont_ask_default = 1
        end
    },

    -- completion
    'neovim/nvim-lspconfig',
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        config = function()
            require("mason").setup()
        end
    },

    -- mason-lspconfig
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                automatic_installation = true,
            })
        end
    },

    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'saadparwaiz1/cmp_luasnip',
    {
        'L3MON4D3/LuaSnip',
        version = 'v2.*',
        config = function()
            require('luasnip.loaders.from_vscode').lazy_load()
            local luasnip = require('luasnip')
            luasnip.filetype_extend('javascript', { 'html' })
            luasnip.filetype_extend('typescript', { 'html' })
            luasnip.filetype_extend('javascriptreact', { 'html' })
            luasnip.filetype_extend('typescriptreact', { 'html' })
        end,
    },
    'rafamadriz/friendly-snippets',
    'onsails/lspkind.nvim',

    -- linting
    'mfussenegger/nvim-lint',

    -- debugging
     "nvim-neotest/nvim-nio",
    'mfussenegger/nvim-dap',
    'rcarriga/nvim-dap-ui',
    'theHamsta/nvim-dap-virtual-text',
    'nvim-telescope/telescope-dap.nvim',
    'leoluz/nvim-dap-go',
    {
        'kevinhwang91/nvim-bqf',
        ft='qf',
        config = function()
            require"bqf".setup({
                preview = {
                    wrap = true
                },
            })
        end,
    },

    --copilot
    ---{
    ---    "yetone/avante.nvim",
    ---    event = "VeryLazy",
    ---    lazy = false,
    ---    version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
    ---    opts = {
    ---        provider = "copilot",
    ---        auto_suggestions_provider = "copilot",
    ---        copilot = {
    ---            endpoint = "https://api.githubcopilot.com",
    ---            model = "claude-3.5-sonnet",
    ---            timeout = 30000, -- Timeout in milliseconds
    ---            temperature = 0,
    ---            max_tokens = 4096,
    ---        },
    ---        behaviour = {
    ---            auto_suggestions = true,
    ---        },
    ---        build = "make",
    ---        mappings = {
    ---            --- @class AvanteConflictMappings
    ---            diff = {
    ---                ours = "co",
    ---                theirs = "ct",
    ---                all_theirs = "ca",
    ---                both = "cb",
    ---                cursor = "cc",
    ---                next = "]x",
    ---                prev = "[x",
    ---            },
    ---            suggestion = {
    ---                accept = "<C-CR>",
    ---                next = "<C-]>",
    ---                prev = "<S-C-]>",
    ---                dismiss = "<C-0>",
    ---            },
    ---            jump = {
    ---                next = "]]",
    ---                prev = "[[",
    ---            },
    ---            submit = {
    ---                normal = "<CR>",
    ---                insert = "<C-s>",
    ---            },
    ---            sidebar = {
    ---                apply_all = "A",
    ---                apply_cursor = "a",
    ---                switch_windows = "<Tab>",
    ---                reverse_switch_windows = "<S-Tab>",
    ---            },
    ---        },
    ---        highlights = {
    ---            ---@type AvanteConflictHighlights
    ---            diff = {
    ---                current = "Visual",
    ---                incoming = "Search",
    ---            }, 
    ---            diff = {
    ---                current = "Visual",
    ---                incoming = "Search",
    ---            },
    ---            sidebar = {
    ---                normal = {
    ---                    bg = "#e5e1d8",
    ---                },
    ---            },
    ---        },
    ---        windows = {
    ---            ---@type "right" | "left" | "top" | "bottom"
    ---            position = "right", -- the position of the sidebar
    ---            wrap = true, -- similar to vim.o.wrap
    ---            width = 30, -- default % based on available width
    ---            sidebar_header = {
    ---                enabled = false -- true, false to enable/disable the header
    ---            },
    ---            input = {
    ---                prefix = "> ",
    ---                height = 8, -- Height of the input window in vertical layout
    ---            },
    ---            ask = {
    ---                floating = false, -- Open the 'AvanteAsk' prompt in a floating window
    ---                start_insert = true, -- Start insert mode when opening the ask window
    ---                border = "none",
    ---                ---@type "ours" | "theirs"
    ---                focus_on_apply = "theirs", -- which diff to focus after applying
    ---            },
    ---        },
    ---        suggestion = {
    ---            debounce = 75,
    ---            throttle = 0,
    ---        },
    ---    },
    ---    dependencies = {
    ---        "nvim-treesitter/nvim-treesitter",
    ---        "stevearc/dressing.nvim",
    ---        "nvim-lua/plenary.nvim",
    ---        "MunifTanjim/nui.nvim",
    ---        --- The below dependencies are optional,
    ---        "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
    ---        "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
    ---        "zbirenbaum/copilot.lua" -- for providers='copilot'
    ---    },
    ---},

    ---"zbirenbaum/copilot.lua" 
})
 









