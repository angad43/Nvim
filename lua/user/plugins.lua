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
          bufferline = true, -- Added integration
        },
      })
      vim.cmd.colorscheme("catppuccin-mocha")
    end,
  },

  -- ======================================================
  -- Navigation: Telescope & File Tree
  -- ======================================================
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
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

  -- ======================================================
  -- UI: Statusline & Tabs
  -- ======================================================
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
          separator_style = "slant", -- Matches your old config style
        },
      })
    end,
  },

  -- ======================================================
  -- Programming: Treesitter & LSP
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
    "neovim/nvim-lspconfig",
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
      local cap = require("cmp_nvim_lsp").default_capabilities()
      -- Modern 0.11 API
      vim.lsp.config("pyright", { capabilities = cap })
      vim.lsp.config("ts_ls", { capabilities = cap })
      vim.lsp.config("clangd", { capabilities = cap })
      vim.lsp.enable({ "pyright", "ts_ls", "clangd", "lua_ls" })
    end,
  },

  -- ======================================================
  -- Formatting & Debugging
  -- ======================================================
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
      format_on_save = { timeout_ms = 500 }, -- Auto-format from old config
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

      -- Python
      require("dap-python").setup("python")

      -- C/C++
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

  -- ======================================================
  -- Completion & Others
  -- ======================================================
  { "hrsh7th/nvim-cmp", dependencies = { "hrsh7th/cmp-nvim-lsp", "L3MON4D3/LuaSnip" } },
  { "windwp/nvim-autopairs", config = true },
  { "numToStr/Comment.nvim", config = true },
}
