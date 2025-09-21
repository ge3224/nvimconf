-- Markdown-specific settings
local augroup = vim.api.nvim_create_augroup('MarkdownSettings', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  group = augroup,
  pattern = 'markdown',
  callback = function()
    vim.bo.tabstop = 2
    vim.bo.shiftwidth = 2
    vim.bo.softtabstop = 2
    vim.bo.expandtab = true
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
  end,
})

return {}