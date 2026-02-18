return {
  'nvim-treesitter/nvim-treesitter-context',
  event = 'BufReadPost',
  opts = {
    max_lines = 3,
  },
  keys = {
    { '<leader>tc', function() require('treesitter-context').toggle() end, desc = '[T]oggle treesitter [C]ontext' },
  },
}
