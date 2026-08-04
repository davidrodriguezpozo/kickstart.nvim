-- Pin a handful of files and jump between them
-- https://github.com/ThePrimeagen/harpoon
-- NOTE: `plenary.nvim` is installed in SECTION 4 of init.lua

vim.pack.add { { src = 'https://github.com/ThePrimeagen/harpoon', version = 'harpoon2' } }

local harpoon = require 'harpoon'
harpoon:setup()

vim.keymap.set('n', '<leader>ha', function() harpoon:list():add() end, { desc = 'Harpoon [A]dd file' })
vim.keymap.set('n', '<leader>he', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = 'Harpoon [E]xplorer' })

for i = 1, 5 do
  vim.keymap.set('n', '<leader>' .. i, function() harpoon:list():select(i) end, { desc = 'Harpoon file ' .. i })
end
