return {
  {
    'obsidian-nvim/obsidian.nvim',
    version = '*',
    ft = 'markdown',
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
        legacy_commands = false,
        daily_notes = {
          folder = 'resources/daily',
        },
      })

      -- Disable default <CR> keymap
      vim.api.nvim_create_autocmd("User", {
        pattern = "ObsidianNoteEnter",
        callback = function(ev)
          vim.keymap.del("n", "<CR>", { buffer = ev.buf })
        end,
      })
    end,
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' },
    ft = { 'markdown' },
    opts = {},
    config = function()
      require('render-markdown').setup {
        enabled = false,
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
      -- Markdown-specific settings and obsidian keymaps
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

          -- Obsidian keymaps (buffer-specific)
          vim.keymap.set('n', 'gf', '<cmd>Obsidian follow_link<CR>', { desc = 'Follow obsidian link', buffer = true })

          vim.keymap.set('n', '<leader>nn', ':Obsidian new<CR>', { desc = 'Create new note', buffer = true })
          vim.keymap.set('n', '<leader>nt', ':Obsidian today<CR>', { desc = 'Open today\'s note', buffer = true })

          -- Visual mode keymaps
          vim.keymap.set('v', '<leader>ne', ':Obsidian extract_note<CR>', { desc = 'Extract selection to new note', buffer = true })
          vim.keymap.set('v', '<leader>nl', ':Obsidian link<CR>', { desc = 'Link selection to existing note', buffer = true })
          vim.keymap.set('v', '<leader>nw', ':Obsidian link_new<CR>', { desc = 'Create new note and link selection', buffer = true })
        end,
      })
    end,
  },
}
