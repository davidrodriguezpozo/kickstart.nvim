-- Keep the enclosing function/class visible at the top of the window
-- https://github.com/nvim-treesitter/nvim-treesitter-context
--
-- NOTE: this plugin tracks the `master` branch of nvim-treesitter, unlike the
-- `main` branch used in SECTION 9 of init.lua. It reads the treesitter tree
-- directly, so it works regardless.

vim.pack.add { 'https://github.com/nvim-treesitter/nvim-treesitter-context' }

require('treesitter-context').setup {
  max_lines = 3,
}

-- NOTE: this shadows the `<leader>tc` "tab close" mapping from SECTION 2,
-- matching the behaviour of the previous lazy.nvim setup.
vim.keymap.set('n', '<leader>tc', function() require('treesitter-context').toggle() end, { desc = '[T]oggle treesitter [C]ontext' })
