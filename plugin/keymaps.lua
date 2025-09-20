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
