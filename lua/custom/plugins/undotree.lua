-- Visualize the undo history as a tree
-- https://github.com/mbbill/undotree

vim.pack.add { 'https://github.com/mbbill/undotree' }

vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, { desc = '[U]ndo tree' })
