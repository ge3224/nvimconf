return {
  'itchyny/calendar.vim',
  config = function()
    vim.keymap.set('n', '<leader>cv', '<cmd>Calendar -view=year -split=vertical -width=27<CR> <C-w>h')
  end,
}
