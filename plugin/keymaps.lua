-- [[ Kickstart Keymap Suggestions ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- [[ Personal Keymaps ]]

-- Move line selections up or down
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { silent = true })
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { silent = true })

-- Keep cursor in centered vertically in the window
vim.keymap.set("n", "<C-d>", "<C-d>zz", { silent = true })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { silent = true })
vim.keymap.set("n", "n", "nzzzv", { silent = true })
vim.keymap.set("n", "N", "Nzzzv", { silent = true })

-- Navigate quickfix list
vim.keymap.set("n", "gn", "<cmd>cn<CR>", { silent = true })
vim.keymap.set("n", "gp", "<cmd>cN<CR>", { silent = true })

vim.keymap.set("n", "<leader>lr", "<cmd>LspRestart<CR>", { silent = true })

-- Occasionally, I need to delete the swap file
vim.keymap.set("n", "<leader>zc", function()
  vim.cmd [[call system("rm -rdf ~/.local/state/nvim/swap")]]
end, { silent = true })

-- Function to generate the numbered links
local function generate_numbered_links()
  -- Prompt for input parameters
  local x = vim.fn.input "Enter chapter number: "
  local count = tonumber(vim.fn.input "Enter number of verses: ")
  local c_id = tonumber(vim.fn.input "Enter the chapter ID: ")
  local v_id = tonumber(vim.fn.input "Enter the initial verse ID: ")

  -- Get current cursor position
  local row = vim.api.nvim_win_get_cursor(0)[1]
  -- Generate the lines
  local lines = {}
  for i = 1, count do
    local line = string.format("### [%s:%d](https://wol.jw.org/en/wol/dx/r1/lp-e/%d/%d)", x, i, c_id, v_id + i - 1)
    table.insert(lines, line)
    -- Add empty line after each entry except the last one
    if i < count then
      table.insert(lines, "")
    end
  end

  -- Insert the lines at current cursor position
  vim.api.nvim_buf_set_lines(0, row - 1, row - 1, false, lines)
end

-- Create the keymapping (adjust the key combination as needed)
vim.keymap.set("n", "<leader>bv", function()
  generate_numbered_links()
end, { noremap = true, desc = "Generate numbered links" })
