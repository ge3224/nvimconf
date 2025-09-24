return {
  {
    'obsidian-nvim/obsidian.nvim',
    version = '*',
    ft = 'markdown',
    config = function()
      -- Setup obsidian with the opts
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
        legacy_commands = false,
      })

      -- Custom keymaps (set after plugin loads)
      vim.keymap.set('n', 'gf', function()
        if vim.bo.filetype == 'markdown' then
          return require('obsidian').util.gf_passthrough()
        else
          return 'gf'
        end
      end, { noremap = false, expr = true, buffer = true })

      vim.keymap.set('n', '<cr>', function()
        return require('obsidian').util.smart_action()
      end, { buffer = true, expr = true })

      vim.keymap.set('n', '<leader>nn', ':Obsidian new<CR>', { desc = 'Create new note', buffer = true })

      -- Visual mode keymaps
      vim.keymap.set('v', '<leader>ne', ':Obsidian extract_note<CR>', { desc = 'Extract selection to new note', buffer = true })
      vim.keymap.set('v', '<leader>nl', ':Obsidian link<CR>', { desc = 'Link selection to existing note', buffer = true })
      vim.keymap.set('v', '<leader>nw', ':Obsidian link_new<CR>', { desc = 'Create new note and link selection', buffer = true })
    end,
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' },
    ft = { 'markdown' },
    opts = {},
    config = function()
      require('render-markdown').setup {
        code = {
          sign = false,
          width = 'block',
          right_pad = 1,
        },
        heading = {
          sign = false,
          icons = { '󰉫 ', '󰉬 ', '󰉭 ', '󰉮 ', '󰉯 ', '󰉰 ' },
        },
      }
      -- Toggle keybinding for render/raw mode
      vim.keymap.set('n', '<leader>mt', ':RenderMarkdown toggle<CR>', { desc = 'Toggle markdown rendering' })
    end,
  },
  {
    dir = vim.fn.stdpath 'config',
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
