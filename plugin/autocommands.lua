vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('treesitter', {
    clear = true,
  }),
  callback = function(args)
    pcall(vim.treesitter.start, args.buf)
  end,
})
