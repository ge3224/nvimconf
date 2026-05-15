vim.api.nvim_create_autocmd('FileType', {
  pattern = '*',
  callback = function()
    vim.opt_local.textwidth = 80
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('treesitter', {
    clear = true,
  }),
  callback = function(args)
    pcall(vim.treesitter.start, args.buf)
  end,
})
