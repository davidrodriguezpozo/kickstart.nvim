-- GitHub Copilot inline suggestions
-- https://github.com/zbirenbaum/copilot.lua

vim.pack.add { 'https://github.com/zbirenbaum/copilot.lua' }

require('copilot').setup {
  suggestion = {
    enabled = true,
    auto_trigger = true,
    debounce = 75,
    keymap = {
      accept = '<Tab>',
      accept_word = false,
      accept_line = false,
      next = '<M-]>',
      prev = '<M-[>',
      dismiss = '<C-]>',
    },
  },
  panel = { enabled = false },
  filetypes = {
    markdown = true,
    yaml = true,
  },
}
