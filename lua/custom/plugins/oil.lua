return {
  'stevearc/oil.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  keys = {
    { '-', '<cmd>Oil<cr>', desc = 'Open parent directory (Oil)' },
  },
  opts = {
    view_options = {
      show_hidden = true,
    },
    keymaps = {
      ['q'] = 'actions.close',
    },
  },
}
