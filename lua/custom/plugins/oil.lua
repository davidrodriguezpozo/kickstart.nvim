-- Edit your filesystem like a buffer
-- https://github.com/stevearc/oil.nvim
-- NOTE: `nvim-web-devicons` is installed in SECTION 4 of init.lua

vim.pack.add { 'https://github.com/stevearc/oil.nvim' }

require('oil').setup {
  view_options = {
    show_hidden = true,
  },
  keymaps = {
    ['q'] = 'actions.close',
  },
}

vim.keymap.set('n', '-', '<cmd>Oil<cr>', { desc = 'Open parent directory (Oil)' })
