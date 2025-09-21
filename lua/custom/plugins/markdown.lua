return {
  {
    'epwalsh/obsidian.nvim',
    version = '*',
    lazy = true,
    ft = 'markdown',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    config = function()
      require('obsidian').setup({
        workspaces = {
          {
            name = 'personal',
            path = '~/vault',
          },
        },
        ui = {
          enable = false,
        },
        mappings = {
          ["gf"] = {
            action = function()
              if vim.bo.filetype == "markdown" then
                return require("obsidian").util.gf_passthrough()
              else
                return "gf"
              end
            end,
            opts = { noremap = false, expr = true, buffer = true },
          },
          ["<cr>"] = {
            action = function()
              return "<cr>"
            end,
            opts = { expr = true, buffer = true },
          },
        },
      })
    end,
  },
  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    build = 'cd app && npm install',
    init = function()
      vim.g.mkdp_filetypes = { 'markdown' }
    end,
    ft = { 'markdown' },
  },
  {
    dir = vim.fn.stdpath('config'),
    name = 'markdown-settings',
    config = function()
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
    end,
  },
}