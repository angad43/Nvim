return {
  -- ======================================================
  -- Colorscheme: Catppuccin
  -- ======================================================
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    config = function()
    require("catppuccin").setup({
      flavour = "mocha",
      integrations = {
        treesitter = true,
        native_lsp = { enabled = true, semantic_tokens = true },
        cmp = true,
        nvimtree = true,
        lualine = true,
        bufferline = true,
        which_key = true,
      },
    })
    vim.cmd.colorscheme("catppuccin-mocha")
    end,
  },

  -- ======================================================
  -- Navigation & UI
  -- ======================================================
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-ui-select.nvim" -- Better UI for code actions
    },
    config = function()
    local telescope = require("telescope")
    telescope.setup({
      extensions = {
        ["ui-select"] = { require("telescope.themes").get_dropdown({}) }
      }
    })
    telescope.load_extension("ui-select")
    local builtin = require("telescope.builtin")
    vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find Files" })
    vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live Grep" })
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
    require("nvim-tree").setup({ view = { width = 30 } })
    end,
  },
  { "folke/which-key.nvim", event = "VeryLazy", opts = {} },
  {
    "nvim-lualine/lualine.nvim",
    config = function() require("lualine").setup() end,
  },
  {
    "akinsho/bufferline.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
    require("bufferline").setup({
      options = {
        diagnostics = "nvim_lsp",
        separator_style = "slant",
      },
    })
    end,
  },

  -- ======================================================
  -- LSP, Mason & Completion
  -- ======================================================
  {
    "williamboman/mason.nvim",
    config = true, -- Simplified mason setup
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = { "pyright", "ts_ls", "clangd", "lua_ls" },
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
    -- This is the modern 0.11+ way to handle capabilities
    local cap = require("cmp_nvim_lsp").default_capabilities()

    -- We use mason-lspconfig to bridge the gap between Mason and the new API
    local servers = { "pyright", "ts_ls", "clangd", "lua_ls" }

    for _, server_name in ipairs(servers) do
      -- Use the new 0.11 API: vim.lsp.config and vim.lsp.enable
      vim.lsp.config(server_name, {
        capabilities = cap,
      })
      end

      -- Actually enable the servers
      vim.lsp.enable(servers)
      end,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    require("luasnip.loaders.from_vscode").lazy_load()

    cmp.setup({
      snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
              mapping = cmp.mapping.preset.insert({
                ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                                                  ["<C-f>"] = cmp.mapping.scroll_docs(4),
                                                  ["<C-Space>"] = cmp.mapping.complete(),
                                                  ["<CR>"] = cmp.mapping.confirm({ select = true }),
                                                  ["<Tab>"] = cmp.mapping(function(fallback)
                                                  if cmp.visible() then cmp.select_next_item()
                                                    elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
                                                      else fallback() end
                                                        end, { "i", "s" }),
              }),
              sources = cmp.config.sources({
                { name = "nvim_lsp" },
                { name = "luasnip" },
                { name = "path" },
              }, { { name = "buffer" } }),
    })
    end,
  },

  -- ======================================================
  -- Programming Support (Treesitter, Formatting, DAP)
  -- ======================================================
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      ensure_installed = { "lua", "python", "javascript", "typescript", "c", "cpp" },
      highlight = { enable = true },
    },
  },
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = {
      formatters_by_ft = {
        c = { "clang-format" },
        cpp = { "clang-format" },
        python = { "black" },
        javascript = { "prettier" },
      },
      format_on_save = { timeout_ms = 500 },
    },
  },
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "mfussenegger/nvim-dap-python",
    },
    config = function()
    local dap, dapui = require("dap"), require("dapui")
    dapui.setup()
    dap.listeners.after.event_initialized["dapui"] = function() dapui.open() end
    dap.listeners.before.event_terminated["dapui"] = function() dapui.close() end
    require("dap-python").setup("python")

    dap.adapters.cppdbg = {
      id = "cppdbg",
      type = "executable",
      command = "C:/Users/hp/.vscode/extensions/ms-vscode.cpptools/debugAdapters/bin/OpenDebugAD7.exe",
    }
    dap.configurations.cpp = {
      {
        name = "Debug",
        type = "cppdbg",
        request = "launch",
        program = function() return vim.fn.input("Exe: ", vim.fn.getcwd() .. "/", "file") end,
        cwd = "${workspaceFolder}",
        stopAtEntry = false,
      },
    }
    dap.configurations.c = dap.configurations.cpp
    end,
  },
  { "windwp/nvim-autopairs", config = true },
  { "numToStr/Comment.nvim", config = true },
}
