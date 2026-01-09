local keymap = vim.keymap.set

-- Basic File Ops
keymap("n", "<leader>w", ":w<CR>", { desc = "Save File" })
keymap("n", "<leader>q", ":q<CR>", { desc = "Quit Neovim" })
keymap("n", "<leader>h", ":nohlsearch<CR>", { desc = "Clear Search Highlight" })

-- Navigation: Windows
keymap("n", "<C-h>", "<C-w>h", { desc = "Move to Left Window" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Move to Bottom Window" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Move to Top Window" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Move to Right Window" })

-- Navigation: Tabs (Bufferline)
keymap("n", "<Tab>", ":BufferLineCycleNext<CR>", { desc = "Next Buffer" })
keymap("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", { desc = "Previous Buffer" })
keymap("n", "<leader>x", ":bd<CR>", { desc = "Close Current Buffer" })

-- UI: File Tree
keymap("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle File Explorer" })

-- Debugging (DAP) - Lazy Safe
local function dap_cmd(callback)
return function()
local ok, dap = pcall(require, "dap")
if ok then callback(dap) else print("DAP not loaded yet!") end
  end
  end

  keymap("n", "<F5>", dap_cmd(function(dap) dap.continue() end), { desc = "Debug: Continue" })
  keymap("n", "<F9>", dap_cmd(function(dap) dap.toggle_breakpoint() end), { desc = "Debug: Toggle Breakpoint" })
  keymap("n", "<F10>", dap_cmd(function(dap) dap.step_over() end), { desc = "Debug: Step Over" })
  keymap("n", "<F11>", dap_cmd(function(dap) dap.step_into() end), { desc = "Debug: Step Into" })

  -- C/C++ Quick Compile & Run
  keymap("n", "<F6>", ":w<CR>:!gcc -g \"%\" -o \"%<\" && \"%<\"<CR>", { desc = "C: Quick Compile & Run" })
  keymap("n", "<F7>", ":w<CR>:!g++ -g \"%\" -o \"%<\" && \"%<\"<CR>", { desc = "C++: Quick Compile & Run" })

  -- Visual Mode Indentation 
  keymap("v", "<", "<gv")
  keymap("v", ">", ">gv")

  -- Insert Mode Power Moves
  keymap("i", "<M-j>", "<Esc>:t.<CR>gi", { desc = "Duplicate Line Down" })
  keymap("i", "<M-k>", "<Esc>:t-1<CR>gi", { desc = "Duplicate Line Up" })

  -- Change Next: Search for word under cursor and change next occurrence
  keymap("n", "cn", "*``cgn", { desc = "Change Next Occurrence" })

