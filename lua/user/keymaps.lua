local keymap = vim.keymap.set
vim.g.mapleader = " "

-- Basic File Ops
keymap("n", "<leader>w", ":w<CR>")
keymap("n", "<leader>q", ":q<CR>")
keymap("n", "<leader>h", ":nohlsearch<CR>")

-- Navigation: Windows
keymap("n", "<C-h>", "<C-w>h")
keymap("n", "<C-j>", "<C-w>j")
keymap("n", "<C-k>", "<C-w>k")
keymap("n", "<C-l>", "<C-w>l")

-- Navigation: Tabs (Bufferline)
keymap("n", "<Tab>", ":BufferLineCycleNext<CR>")
keymap("n", "<S-Tab>", ":BufferLineCyclePrev<CR>")
keymap("n", "<leader>x", ":bd<CR>")

-- UI: File Tree
keymap("n", "<leader>e", ":NvimTreeToggle<CR>")

-- ======================================================
-- Debugging (DAP) - Safe Version
-- ======================================================

-- Use a local function to avoid requiring 'dap' on startup
local function dap_cmd(callback)
  return function()
    local ok, dap = pcall(require, "dap")
    if ok then
      callback(dap)
    else
      print("DAP not loaded yet. Install plugins first!")
    end
  end
end

keymap("n", "<F5>", dap_cmd(function(dap) dap.continue() end))
keymap("n", "<F9>", dap_cmd(function(dap) dap.toggle_breakpoint() end))
keymap("n", "<F10>", dap_cmd(function(dap) dap.step_over() end))
keymap("n", "<F11>", dap_cmd(function(dap) dap.step_into() end))

-- C/C++ Quick Compile & Run
keymap("n", "<F6>", ":w<CR>:!gcc -g \"%\" -o \"%<\" && \"%<\"<CR>")
keymap("n", "<F7>", ":w<CR>:!g++ -g \"%\" -o \"%<\" && \"%<\"<CR>")

-- Visual Mode Indentation
keymap("v", "<", "<gv")
keymap("v", ">", ">gv")

-- Insert Mode Power Moves (from your old config)
keymap("i", "<M-j>", "<Esc>:t.<CR>gi") -- Duplicate line down
keymap("i", "<M-k>", "<Esc>:t-1<CR>gi") -- Duplicate line up

keymap("n","cn","*``cgn")
