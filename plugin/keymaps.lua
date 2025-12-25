--[[ Personal Keymaps ]]

-- Move line selections up or down
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { silent = true })
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { silent = true })

-- Keep cursor in centered vertically in the window
vim.keymap.set('n', '<C-d>', '<C-d>zz', { silent = true })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { silent = true })
vim.keymap.set('n', 'n', 'nzzzv', { silent = true })
vim.keymap.set('n', 'N', 'Nzzzv', { silent = true })

-- Navigate quickfix list
vim.keymap.set('n', 'gn', '<cmd>cn<CR>', { silent = true })
vim.keymap.set('n', 'gp', '<cmd>cN<CR>', { silent = true })

-- Copy cursor position to clipboard (filepath:line:col)
vim.keymap.set('n', '<leader>yl', function()
  local filepath = vim.fn.expand '%:p'
  local line = vim.fn.line '.'
  local col = vim.fn.col '.'
  local position = string.format('%s:%d:%d', filepath, line, col)
  vim.fn.setreg('+', position)
  vim.notify('Copied: ' .. position, vim.log.levels.INFO)
end, { desc = 'Copy cursor position to clipboard' })
