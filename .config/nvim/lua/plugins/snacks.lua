vim.g.snacks_animate = false

local excluded = {
  "node_modules/",
  "dist/",
  ".next/",
  ".vite/",
  ".git/",
  ".gitlab/",
  "build/",
  "target/",
  "dadbod_ui/tmp/",
  "dadbod_ui/dev/",

  "package-lock.json",
  "pnpm-lock.yaml",
  "yarn.lock",
}

local root_patterns = {
  -- directories
  "client",
  "server",

  -- version control systems
  "_darcs",
  ".hg",
  ".bzr",
  ".svn",
  ".git",

  -- build tools
  "Makefile",
  "CMakeLists.txt",
  "build.gradle",
  "build.gradle.kts",
  "pom.xml",
  "build.xml",

  -- docker
  "Dockerfile",
  "docker-compose.yml",

  -- node.js and javascript
  "package.json",
  "package-lock.json",
  "yarn.lock",
  ".nvmrc",
  "gulpfile.js",
  "Gruntfile.js",

  -- python
  "requirements.txt",
  "Pipfile",
  "pyproject.toml",
  "setup.py",
  "tox.ini",

  -- rust
  "Cargo.toml",

  -- go
  "go.mod",

  -- elixir
  "mix.exs",

  -- configuration files
  ".prettierrc",
  ".prettierrc.json",
  ".prettierrc.yaml",
  ".prettierrc.yml",
  ".eslintrc",
  ".eslintrc.json",
  ".eslintrc.js",
  ".eslintrc.cjs",
  ".eslintignore",
  ".stylelintrc",
  ".stylelintrc.json",
  ".stylelintrc.yaml",
  ".stylelintrc.yml",
  ".editorconfig",
  ".gitignore",

  -- html projects
  "index.html",

  -- miscellaneous
  "README.md",
  "README.rst",
  "LICENSE",
  "Vagrantfile",
  "Procfile",
  ".env",
  ".env.example",
  "config.yaml",
  "config.yml",
  ".terraform",
  "terraform.tfstate",
  ".kitchen.yml",
  "Berksfile",
}
vim.g.root_spec = { "lsp", root_patterns, "cwd" }

return {
  "folke/snacks.nvim",
  opts = {
    -- need notifier for disabling "No notifications available"
    notifier = { enabled = true },

    picker = {
      sources = {
        files = {
          hidden = true,
          ignored = true,
        },
      },
      -- show hidden files like .env
      hidden = true,
      -- show files ignored by git like node_modules
      ignored = true,

      exclude = excluded,
    },
  },
}