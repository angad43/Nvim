return {
  -- Colorscheme: Catppuccin
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
        gitsigns = true, -- Added Catppuccin git integration
        neogit = true,
        diffview = true,
      },
    })
    vim.cmd.colorscheme("catppuccin-mocha")
    end,
  },

  -- Navigation & UI
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
    },
    config = function()
    local telescope = require("telescope")
    telescope.setup({
      extensions = {
        ["ui-select"] = { require("telescope.themes").get_dropdown({}) },
      },
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
    config = function()
    require("lualine").setup({
      options = { theme = "catppuccin" },
      sections = {
        lualine_b = { "branch", "diff", "diagnostics" }, -- Visual git status in bar
      },
    })
    end,
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
  -- LSP, Mason & Completion
  { "williamboman/mason.nvim", config = true },
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
    local cap = require("cmp_nvim_lsp").default_capabilities()
    local servers = { "pyright", "ts_ls", "clangd", "lua_ls" }
    for _, server_name in ipairs(servers) do
      vim.lsp.config(server_name, { capabilities = cap })
      end
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
      snippet = {
        expand = function(args)
        luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-Space>"] = cmp.mapping.complete(),
                                          ["<CR>"] = cmp.mapping.confirm({ select = true }),
                                          ["<Tab>"] = cmp.mapping(function(fallback)
                                          if cmp.visible() then
                                            cmp.select_next_item()
                                            elseif luasnip.expand_or_jumpable() then
                                              luasnip.expand_or_jump()
                                              else
                                                fallback()
                                                end
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
  -- Programming Support (Treesitter, Formatting, DAP)
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

  -- Visual Git Integration
  {
    "lewis6991/gitsigns.nvim",
    config = function()
    require("gitsigns").setup({
      current_line_blame = true, -- Toggle with <leader>gb
      current_line_blame_opts = { delay = 500, virt_text_pos = "eol" },
      signcolumn = true,
      numhl = true,      -- Highlight line numbers
      word_diff = true,   -- Highlight specific word changes in line
      on_attach = function(bufnr)
      local gs = package.loaded.gitsigns
      local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      map("n", "]c", function() if vim.wo.diff then return "]c" end vim.schedule(function() gs.next_hunk() end) return "<Ignore>" end, { expr = true, desc = "Next Hunk" })
      map("n", "[c", function() if vim.wo.diff then return "[c" end vim.schedule(function() gs.prev_hunk() end) return "<Ignore>" end, { expr = true, desc = "Prev Hunk" })

      -- Visual Actions
      map("n", "<leader>gp", gs.preview_hunk, { desc = "Preview Change Window" })
      map("n", "<leader>gr", gs.reset_hunk, { desc = "Reset Change" })
      map("n", "<leader>gb", gs.toggle_current_line_blame, { desc = "Toggle Git Blame" })
      end,
    })
    end,
  },
  {
    "NeogitOrg/neogit",
    dependencies = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim" },
    config = true,
    keys = {
      { "<leader>gs", ":Neogit<CR>", desc = "Git Status (Neogit)" },
    },
  },
  {
    "sindrets/diffview.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diff Project" },
      { "<leader>gx", "<cmd>DiffviewClose<cr>", desc = "Diff Project" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "Current File History" },
    },
  },
  {
    "isakbm/gitgraph.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      symbols = { merge_commit = "M", commit = "●" },
      format = { timestamp = "%H:%M:%S %d-%m-%Y", fields = { "hash", "timestamp", "author", "branch_name", "tag" } },
    },
    keys = {
      {
        "<leader>gl",
        function()
        require("gitgraph").draw({}, { all = true, max_count = 5000 })
        end,
        desc = "GitGraph Draw",
      },
    },
  },
  {
    "akinsho/git-conflict.nvim",
    version = "*",
    config = function()
    require("git-conflict").setup({
      default_mappings = true, -- co (ours), ct (theirs), cb (both), c0 (none)
    })
    end,
  },
  -- Code Structure (IDE features)
  {
    "hedyhli/outline.nvim",
    config = function()
    require("outline").setup({})
    end,
    keys = {
      { "<leader>so", "<cmd>Outline<CR>", desc = "Toggle Outline" },
    },
  },
}
