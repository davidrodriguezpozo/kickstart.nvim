--[[

=====================================================================
====================== PERSONAL NEOVIM CONFIG =======================
=====================================================================

Forked from kickstart.nvim, then reorganized into sections and
migrated from `lazy.nvim` to the built-in `vim.pack` plugin manager.

Layout:
  SECTION 1  Options
  SECTION 2  Keymaps & autocmds
  SECTION 3  Plugin manager (vim.pack) & build hooks
  SECTION 4  UI / core UX plugins
  SECTION 5  Search & navigation (snacks.nvim)
  SECTION 6  LSP
  SECTION 7  Formatting
  SECTION 8  Autocomplete & snippets
  SECTION 9  Treesitter
  SECTION 10 Extra modules (kickstart.plugins.*, custom.plugins.*)

Server definitions live in `lsp/*.lua` and are turned on with
`vim.lsp.enable` at the end of SECTION 6.

To inspect plugin state and pending updates, run
  :lua vim.pack.update(nil, { offline = true })
To update plugins, run
  :lua vim.pack.update()

--]]

-- ============================================================
-- SECTION 1: OPTIONS
-- Core Neovim settings, leaders, options
-- ============================================================
do
  -- Enable faster startup by caching compiled Lua modules
  vim.loader.enable()

  -- Set cursor to block always
  -- See `:help 'guicursor'`
  -- This is a global option, so it must be set before any windows are opened
  vim.opt.guicursor = 'n-v-c:block-Cursor/lCursor,i:block-Cursor/lCursor-blinkon175'

  vim.o.winborder = 'rounded'

  -- Set <space> as the leader key
  -- See `:help mapleader`
  --  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
  vim.g.mapleader = ' '
  vim.g.maplocalleader = ' '

  -- Set to true if you have a Nerd Font installed and selected in the terminal
  vim.g.have_nerd_font = true

  -- [[ Setting options ]]
  --  See `:help vim.o`

  -- Make line numbers default
  vim.o.number = true
  vim.o.relativenumber = true

  -- Enable mouse mode, can be useful for resizing splits for example!
  vim.o.mouse = 'a'

  -- Don't show the mode, since it's already in the status line
  vim.o.showmode = false

  -- Sync clipboard between OS and Neovim.
  --  Schedule the setting after `UiEnter` because it can increase startup-time.
  --  See `:help 'clipboard'`
  vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

  -- Enable break indent
  vim.o.breakindent = true

  -- Enable undo/redo changes even after closing and reopening a file
  vim.o.undofile = true

  -- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
  vim.o.ignorecase = true
  vim.o.smartcase = true

  -- Keep signcolumn on by default
  vim.o.signcolumn = 'yes'

  -- Decrease update time
  vim.o.updatetime = 250

  -- Decrease mapped sequence wait time
  vim.o.timeoutlen = 300

  -- Configure how new splits should be opened
  vim.o.splitright = true
  vim.o.splitbelow = true

  -- Sets how neovim will display certain whitespace characters in the editor.
  --  See `:help 'list'` and `:help 'listchars'`
  vim.o.list = true
  vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

  -- Preview substitutions live, as you type!
  vim.o.inccommand = 'split'

  -- Show which line your cursor is on
  vim.o.cursorline = true

  -- Minimal number of screen lines to keep above and below the cursor.
  vim.o.scrolloff = 10

  -- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
  -- instead raise a dialog asking if you wish to save the current file(s)
  -- See `:help 'confirm'`
  vim.o.confirm = true
end

-- ============================================================
-- SECTION 2: KEYMAPS & AUTOCMDS
-- basic keymaps, diagnostics, basic autocmds
-- ============================================================
do
  -- [[ Basic Keymaps ]]
  --  See `:help vim.keymap.set()`

  -- Clear highlights on search when pressing <Esc> in normal mode
  --  See `:help hlsearch`
  vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

  -- Diagnostic Config
  --  See `:help vim.diagnostic.Opts`
  vim.diagnostic.config {
    severity_sort = true,
    float = { border = 'rounded', source = 'if_many' },
    underline = { severity = vim.diagnostic.severity.ERROR },
    signs = vim.g.have_nerd_font and {
      text = {
        [vim.diagnostic.severity.ERROR] = '󰅚 ',
        [vim.diagnostic.severity.WARN] = '󰀪 ',
        [vim.diagnostic.severity.INFO] = '󰋽 ',
        [vim.diagnostic.severity.HINT] = '󰌶 ',
      },
    } or {},
    virtual_text = {
      source = 'if_many',
      spacing = 2,
      format = function(diagnostic)
        local diagnostic_message = {
          [vim.diagnostic.severity.ERROR] = diagnostic.message,
          [vim.diagnostic.severity.WARN] = diagnostic.message,
          [vim.diagnostic.severity.INFO] = diagnostic.message,
          [vim.diagnostic.severity.HINT] = diagnostic.message,
        }
        return diagnostic_message[diagnostic.severity]
      end,
    },
  }

  vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

  -- Tabs
  vim.keymap.set('n', '<leader>tn', '<cmd>tabnew<CR>', { desc = 'New [T]ab' })
  vim.keymap.set('n', '<leader>tc', '<cmd>tabclose<CR>', { desc = '[T]ab [C]lose' })
  vim.keymap.set('n', '<leader>tl', '<cmd>tabnext<CR>', { desc = '[T]ab Next' })
  vim.keymap.set('n', '<leader>tp', '<cmd>tabprevious<CR>', { desc = '[T]ab [P]revious' })

  -- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
  -- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
  -- is not what someone will guess without a bit more experience.
  vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

  -- Keybinds to make split navigation easier.
  --  Use CTRL+<hjkl> to switch between windows
  --
  --  See `:help wincmd` for a list of all window commands
  vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
  vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
  vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
  vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

  -- [[ Basic Autocommands ]]
  --  See `:help lua-guide-autocommands`

  -- Highlight when yanking (copying) text
  --  Try it with `yap` in normal mode
  --  See `:help vim.hl.on_yank()`
  vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function() vim.hl.on_yank() end,
  })

  vim.api.nvim_create_autocmd('FileType', {
    desc = 'Use 2-space indentation for JS/TS files',
    group = vim.api.nvim_create_augroup('js-ts-indent', { clear = true }),
    pattern = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
    callback = function()
      vim.bo.shiftwidth = 2
      vim.bo.tabstop = 2
      vim.bo.softtabstop = 2
      vim.bo.expandtab = true
    end,
  })
end

-- ============================================================
-- SECTION 3: PLUGIN MANAGER INTRO
-- vim.pack intro, build hooks
-- ============================================================
do
  -- [[ Intro to `vim.pack` ]]
  -- `vim.pack` is the plugin manager built into Neovim (0.12+),
  --  which provides a Lua interface for installing and managing plugins.
  --
  --  See `:help vim.pack` and `:help vim.pack-examples`.
  --
  --  Unlike `lazy.nvim`, `vim.pack` has no declarative lazy-loading keys
  --  (`event` / `ft` / `cmd` / `keys`); a plugin is loaded when `vim.pack.add`
  --  runs. If startup time becomes a problem, individual plugins can be
  --  deferred with `vim.pack.add({ ... }, { load = false })` and activated
  --  later with `vim.cmd.packadd`.

  local function run_build(name, cmd, cwd)
    local result = vim.system(cmd, { cwd = cwd }):wait()
    if result.code ~= 0 then
      local stderr = result.stderr or ''
      local stdout = result.stdout or ''
      local output = stderr ~= '' and stderr or stdout
      if output == '' then output = 'No output from build command.' end
      vim.notify(('Build failed for %s:\n%s'):format(name, output), vim.log.levels.ERROR)
    end
  end

  -- This autocommand runs after a plugin is installed or updated and
  --  runs the appropriate build command for that plugin if necessary.
  --
  -- See `:help vim.pack-events`
  vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(ev)
      local name = ev.data.spec.name
      local kind = ev.data.kind
      if kind ~= 'install' and kind ~= 'update' then return end

      if name == 'LuaSnip' then
        -- Build step is needed for regex support in snippets.
        if vim.fn.has 'win32' ~= 1 and vim.fn.executable 'make' == 1 then run_build(name, { 'make', 'install_jsregexp' }, ev.data.path) end
        return
      end

      if name == 'nvim-treesitter' then
        if not ev.data.active then vim.cmd.packadd 'nvim-treesitter' end
        vim.cmd 'TSUpdate'
        return
      end
    end,
  })
end

---Because most plugins are hosted on GitHub, you can use the helper
---function to have less repetition in the following sections.
---@param repo string
---@return string
local function gh(repo) return 'https://github.com/' .. repo end

-- ============================================================
-- SECTION 4: UI / CORE UX PLUGINS
-- guess-indent, gitsigns, which-key, colorscheme, todo-comments,
-- mini modules, noice, git-blame
-- ============================================================
do
  -- Detect tabstop and shiftwidth automatically.
  -- JS/TS are excluded because SECTION 2 pins them to 2 spaces.
  vim.pack.add { gh 'NMAC427/guess-indent.nvim' }
  require('guess-indent').setup {
    filetype_exclude = {
      'netrw',
      'tutor',
      'javascript',
      'javascriptreact',
      'typescript',
      'typescriptreact',
    },
  }

  -- Adds git related signs to the gutter, as well as utilities for managing changes.
  -- NOTE: the recommended hunk keymaps are added by `kickstart.plugins.gitsigns`
  -- in SECTION 10, which re-runs `setup` with these same signs plus `on_attach`.
  vim.pack.add { gh 'lewis6991/gitsigns.nvim' }
  require('gitsigns').setup {
    signs = {
      add = { text = '+' }, ---@diagnostic disable-line: missing-fields
      change = { text = '~' }, ---@diagnostic disable-line: missing-fields
      delete = { text = '_' }, ---@diagnostic disable-line: missing-fields
      topdelete = { text = '‾' }, ---@diagnostic disable-line: missing-fields
      changedelete = { text = '~' }, ---@diagnostic disable-line: missing-fields
    },
  }

  -- Icons used by oil.nvim, trouble.nvim and others
  vim.pack.add { gh 'nvim-tree/nvim-web-devicons' }

  -- Shared Lua utilities used by todo-comments, harpoon, ...
  vim.pack.add { gh 'nvim-lua/plenary.nvim' }

  -- Useful plugin to show you pending keybinds.
  vim.pack.add { gh 'folke/which-key.nvim' }
  require('which-key').setup {
    -- Delay between pressing a key and opening which-key (milliseconds)
    delay = 0,
    icons = { mappings = vim.g.have_nerd_font },
    -- Document existing key chains
    spec = {
      { '<leader>s', group = '[S]earch', mode = { 'n', 'v' } },
      { '<leader>t', group = '[T]oggle' },
      { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      { '<leader>x', group = 'Trouble' },
      { '<leader>g', group = '[G]it' },
      { 'gr', group = 'LSP Actions', mode = { 'n' } },
    },
  }

  -- Fancier UI for messages, cmdline and popupmenu
  vim.pack.add { gh 'MunifTanjim/nui.nvim', gh 'folke/noice.nvim' }
  require('noice').setup {
    lsp = {
      override = {
        ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
        ['vim.lsp.util.stylize_markdown'] = true,
      },
    },
    presets = {
      bottom_search = true,
      command_palette = true,
      long_message_to_split = true,
      inc_rename = true,
      lsp_doc_border = true,
    },
  }

  -- [[ Colorscheme ]]
  vim.pack.add { gh 'folke/tokyonight.nvim' }
  ---@diagnostic disable-next-line: missing-fields
  require('tokyonight').setup {
    styles = {
      comments = { italic = false }, -- Disable italics in comments
    },
  }

  vim.cmd.colorscheme 'tokyonight-night'

  -- Non-italic comments, transparent background
  vim.cmd.hi 'Comment gui=none'
  vim.cmd 'hi Normal guibg=none'

  -- Highlight todo, notes, etc in comments
  vim.pack.add { gh 'folke/todo-comments.nvim' }
  require('todo-comments').setup { signs = false }

  -- Inline git blame virtual text
  vim.pack.add { gh 'f-person/git-blame.nvim' }

  -- [[ mini.nvim ]]
  --  A collection of various small independent plugins/modules
  vim.pack.add { gh 'nvim-mini/mini.nvim' }

  -- Better Around/Inside textobjects
  --
  -- Examples:
  --  - va)  - [V]isually select [A]round [)]paren
  --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
  --  - ci'  - [C]hange [I]nside [']quote
  require('mini.ai').setup { n_lines = 500 }

  -- Add/delete/replace surroundings (brackets, quotes, etc.)
  --
  -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
  -- - sd'   - [S]urround [D]elete [']quotes
  -- - sr)'  - [S]urround [R]eplace [)] [']
  require('mini.surround').setup()

  -- Simple and easy statusline.
  local statusline = require 'mini.statusline'
  statusline.setup { use_icons = vim.g.have_nerd_font }

  -- Set the cursor location section to LINE:COLUMN
  ---@diagnostic disable-next-line: duplicate-set-field
  statusline.section_location = function() return '%2l:%-2v' end
end

-- ============================================================
-- SECTION 5: SEARCH & NAVIGATION
-- snacks.nvim: picker, explorer, terminal, notifier, ...
-- ============================================================
do
  -- snacks.nvim replaces telescope (picker) and neo-tree (explorer).
  --  See https://github.com/folke/snacks.nvim
  vim.pack.add { gh 'folke/snacks.nvim' }

  ---@type snacks.Config
  require('snacks').setup {
    picker = {
      enabled = true,
      win = {
        input = {
          keys = {
            ['<c-d>'] = { 'preview_scroll_down', mode = { 'i', 'n' } },
            ['<c-u>'] = { 'preview_scroll_up', mode = { 'i', 'n' } },
          },
        },
      },
    },
    explorer = { enabled = true },
    notifier = { enabled = true },
    input = { enabled = true },
    dashboard = { enabled = true },
    scroll = { enabled = false },
    statuscolumn = { enabled = true },
    scope = { enabled = true },
    words = { enabled = true },
    quickfile = { enabled = true },
    bigfile = { enabled = true },
    terminal = { enabled = true },
    git = { enabled = true },
    zen = { enabled = true },
    indent = {
      enabled = true,
      exclude = { 'python' },
    },
  }

  -- Picker keymaps
  vim.keymap.set('n', '<leader>sh', function() Snacks.picker.help() end, { desc = '[S]earch [H]elp' })
  vim.keymap.set('n', '<leader>sk', function() Snacks.picker.keymaps() end, { desc = '[S]earch [K]eymaps' })
  vim.keymap.set('n', '<leader>sf', function() Snacks.picker.files() end, { desc = '[S]earch [F]iles' })
  vim.keymap.set('n', '<leader>sF', function() Snacks.picker.files { hidden = true } end, { desc = '[S]earch hidden [F]iles' })
  vim.keymap.set('n', '<leader>ss', function() Snacks.picker() end, { desc = '[S]earch [S]elect Snacks' })
  vim.keymap.set('n', '<leader>sw', function() Snacks.picker.grep_word() end, { desc = '[S]earch current [W]ord' })
  vim.keymap.set('n', '<leader>sg', function() Snacks.picker.grep() end, { desc = '[S]earch by [G]rep' })
  vim.keymap.set('n', '<leader>sd', function() Snacks.picker.diagnostics() end, { desc = '[S]earch [D]iagnostics' })
  vim.keymap.set('n', '<leader>sr', function() Snacks.picker.resume() end, { desc = '[S]earch [R]esume' })
  vim.keymap.set('n', '<leader>s.', function() Snacks.picker.recent() end, { desc = '[S]earch Recent Files ("." for repeat)' })
  vim.keymap.set('n', '<leader><leader>', function() Snacks.picker.buffers() end, { desc = '[ ] Find existing buffers' })
  vim.keymap.set('n', '<leader>/', function() Snacks.picker.lines() end, { desc = '[/] Fuzzily search in current buffer' })
  vim.keymap.set('n', '<leader>s/', function() Snacks.picker.grep_buffers() end, { desc = '[S]earch [/] in Open Files' })
  vim.keymap.set('n', '<leader>sn', function() Snacks.picker.files { cwd = vim.fn.stdpath 'config' } end, { desc = '[S]earch [N]eovim files' })
  vim.keymap.set('n', '<leader>sN', function() Snacks.picker.notifications() end, { desc = '[S]earch [N]otification history' })

  -- Explorer
  vim.keymap.set('n', '\\', function() Snacks.explorer() end, { desc = 'File Explorer' })

  -- Terminal
  vim.keymap.set('n', '<leader>tt', function() Snacks.terminal() end, { desc = '[T]oggle [T]erminal' })

  -- Git
  vim.keymap.set('n', '<leader>go', function() Snacks.gitbrowse() end, { desc = '[G]it Browse ([O]pen)' })

  -- Zen mode
  vim.keymap.set('n', '<leader>tz', function() Snacks.zen() end, { desc = '[T]oggle [Z]en Mode' })

  -- Word references (jump between LSP references of word under cursor)
  vim.keymap.set('n', ']w', function() Snacks.words.jump(vim.v.count1) end, { desc = 'Next word reference' })
  vim.keymap.set('n', '[w', function() Snacks.words.jump(-vim.v.count1) end, { desc = 'Prev word reference' })
end

-- ============================================================
-- SECTION 6: LSP
-- LSP keymaps, Mason tool installation, server activation
-- ============================================================
do
  -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
  -- used for completion, annotations and signatures of Neovim apis
  vim.pack.add { gh 'folke/lazydev.nvim' }
  require('lazydev').setup {
    library = {
      -- Load luvit types when the `vim.uv` word is found
      { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
    },
  }

  -- Useful status updates for LSP.
  vim.pack.add { gh 'j-hui/fidget.nvim' }
  require('fidget').setup {}

  --  This function gets run when an LSP attaches to a particular buffer.
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
    callback = function(event)
      local map = function(keys, func, desc, mode)
        mode = mode or 'n'
        vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
      end

      -- Rename the variable under your cursor.
      map('grn', vim.lsp.buf.rename, '[R]e[n]ame')

      -- Execute a code action, usually your cursor needs to be on top of an error
      -- or a suggestion from your LSP for this to activate.
      map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })

      -- WARN: This is not Goto Definition, this is Goto Declaration.
      map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

      -- Navigation pickers are provided by snacks.nvim (SECTION 5)
      map('grr', function() Snacks.picker.lsp_references() end, '[G]oto [R]eferences')
      map('gri', function() Snacks.picker.lsp_implementations() end, '[G]oto [I]mplementation')
      map('grd', function() Snacks.picker.lsp_definitions() end, '[G]oto [D]efinition')
      map('grt', function() Snacks.picker.lsp_type_definitions() end, '[G]oto [T]ype Definition')
      map('gO', function() Snacks.picker.lsp_symbols() end, 'Open Document Symbols')
      map('gW', function() Snacks.picker.lsp_workspace_symbols() end, 'Open Workspace Symbols')

      -- Highlight references of the word under the cursor while it rests there.
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if client and client:supports_method('textDocument/documentHighlight', event.buf) then
        local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
          buffer = event.buf,
          group = highlight_augroup,
          callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
          buffer = event.buf,
          group = highlight_augroup,
          callback = vim.lsp.buf.clear_references,
        })

        vim.api.nvim_create_autocmd('LspDetach', {
          group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
          callback = function(event2)
            vim.lsp.buf.clear_references()
            vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
          end,
        })
      end

      -- Toggle inlay hints, if the language server supports them
      if client and client:supports_method('textDocument/inlayHint', event.buf) then
        map('<leader>th', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }) end, '[T]oggle Inlay [H]ints')
      end
    end,
  })

  vim.pack.add {
    gh 'neovim/nvim-lspconfig',
    gh 'mason-org/mason.nvim',
    gh 'mason-org/mason-lspconfig.nvim',
    gh 'WhoIsSethDaniel/mason-tool-installer.nvim',
  }

  -- Automatically install LSPs and related tools to stdpath for Neovim
  require('mason').setup {}

  -- Translates between nvim-lspconfig server names and mason.nvim package names
  -- (e.g. lua_ls <-> lua-language-server). Servers are enabled explicitly below,
  -- so automatic enabling is turned off.
  require('mason-lspconfig').setup { automatic_enable = false }

  -- Ensure the servers and tools below are installed.
  --  To check status or install other tools manually, run `:Mason`.
  require('mason-tool-installer').setup {
    ensure_installed = {
      'lua-language-server',
      'stylua',
      'ruff',
      'tailwindcss-language-server',
      { 'vtsls', version = '0.2.9' },
      'vue-language-server',
      'ty',
    },
  }

  -- Enable LSP servers. Their configuration lives in `lsp/*.lua`, which Neovim
  -- picks up automatically from the runtimepath.
  --  See `:help lsp-config`
  vim.lsp.enable { 'lua_ls', 'ruff', 'tailwindcss', 'ty', 'vtsls', 'vue_ls' }
end

-- ============================================================
-- SECTION 7: FORMATTING
-- conform.nvim setup and keymap
-- ============================================================
do
  vim.pack.add { gh 'stevearc/conform.nvim' }
  require('conform').setup {
    notify_on_error = false,
    format_on_save = function(bufnr)
      -- Disable "format_on_save lsp_fallback" for languages that don't
      -- have a well standardized coding style.
      local disable_filetypes = { c = true, cpp = true }
      if disable_filetypes[vim.bo[bufnr].filetype] then
        return nil
      else
        return {
          timeout_ms = 5000,
          lsp_format = 'fallback',
        }
      end
    end,
    formatters_by_ft = {
      lua = { 'stylua' },
      python = { 'ruff_format', 'ruff_organize_imports' },
      javascript = { 'prettier' },
      javascriptreact = { 'prettier' },
      typescript = { 'prettier' },
      typescriptreact = { 'biome' },
      css = { 'prettier' },
      scss = { 'prettier' },
      html = { 'prettier' },
      vue = { 'prettier' },
    },
    formatters = {
      prettier = {
        prepend_args = { '--single-attribute-per-line' },
      },
      ruff_format = {
        append_args = { '--line-length', '88' },
      },
      ruff_organize_imports = {
        append_args = { '--config', 'lint.isort.combine-as-imports=true' },
      },
    },
  }

  vim.keymap.set({ 'n', 'v' }, '<leader>f', function() require('conform').format { async = true, lsp_format = 'fallback' } end, { desc = '[F]ormat buffer' })
end

-- ============================================================
-- SECTION 8: AUTOCOMPLETE & SNIPPETS
-- blink.cmp and luasnip setup
-- ============================================================
do
  -- [[ Snippet Engine ]]
  --  The `make install_jsregexp` build step is handled by the PackChanged
  --  autocommand in SECTION 3.
  vim.pack.add { { src = gh 'L3MON4D3/LuaSnip', version = vim.version.range '2.*' } }
  require('luasnip').setup {}

  -- [[ Autocomplete Engine ]]
  vim.pack.add { { src = gh 'saghen/blink.cmp', version = vim.version.range '1.*' } }
  require('blink.cmp').setup {
    keymap = {
      -- 'default' (recommended) for mappings similar to built-in completions
      --   <c-y> to accept ([y]es) the completion.
      -- See `:help blink-cmp-config-keymap` for defining your own keymap
      preset = 'default',
    },

    appearance = {
      -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      nerd_font_variant = 'mono',
    },

    completion = {
      documentation = { auto_show = true, auto_show_delay_ms = 200 },
    },

    sources = {
      default = { 'lsp', 'path', 'snippets', 'lazydev' },
      providers = {
        lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
      },
    },

    snippets = { preset = 'luasnip' },

    -- Use the rust fuzzy matcher when a prebuilt binary is available,
    -- warning and falling back to the Lua implementation otherwise.
    fuzzy = { implementation = 'prefer_rust_with_warning' },

    -- Shows a signature help window while you type arguments for a function
    signature = { enabled = true },
  }

  -- Broadcast blink.cmp completion capabilities to every LSP server.
  -- Servers start lazily when a matching buffer is opened, so running this
  -- after `vim.lsp.enable` in SECTION 6 is fine.
  vim.lsp.config('*', {
    capabilities = require('blink.cmp').get_lsp_capabilities(),
  })
end

-- ============================================================
-- SECTION 9: TREESITTER
-- Parser installation, syntax highlighting, indentation, textobjects
-- ============================================================
do
  -- [[ Configure Treesitter ]]
  --  Used to highlight, edit, and navigate code
  --
  --  NOTE: this uses the `main` branch of nvim-treesitter, whose API differs
  --  completely from the old `master` branch: there is no `ensure_installed`
  --  or `highlight` / `indent` options table. Parsers are installed with
  --  `require('nvim-treesitter').install()` and highlighting is turned on
  --  per-buffer with `vim.treesitter.start()`.
  vim.pack.add {
    { src = gh 'nvim-treesitter/nvim-treesitter', version = 'main' },
    { src = gh 'nvim-treesitter/nvim-treesitter-textobjects', version = 'main' },
  }

  local parsers = {
    'bash',
    'c',
    'css',
    'diff',
    'html',
    'javascript',
    'json',
    'lua',
    'luadoc',
    'markdown',
    'markdown_inline',
    'python',
    'query',
    'toml',
    'tsx',
    'typescript',
    'vim',
    'vimdoc',
    'vue',
    'yaml',
  }
  require('nvim-treesitter').install(parsers)

  ---@param buf integer
  ---@param language string
  local function treesitter_try_attach(buf, language)
    -- Check if a parser exists and load it
    if not vim.treesitter.language.add(language) then return end
    -- Enable syntax highlighting and other treesitter features
    vim.treesitter.start(buf, language)

    -- Enable treesitter based indentation when an indent query is available.
    -- Without one, `indentexpr` falls back to Vim's built-in indenting.
    local has_indent_query = vim.treesitter.query.get(language, 'indents') ~= nil
    if has_indent_query then vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" end
  end

  local available_parsers = require('nvim-treesitter').get_available()
  vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('treesitter-attach', { clear = true }),
    callback = function(args)
      local buf, filetype = args.buf, args.match

      local language = vim.treesitter.language.get_lang(filetype)
      if not language then return end

      local installed_parsers = require('nvim-treesitter').get_installed 'parsers'

      if vim.tbl_contains(installed_parsers, language) then
        -- Enable the parser if it is already installed
        treesitter_try_attach(buf, language)
      elseif vim.tbl_contains(available_parsers, language) then
        -- Auto-install an available parser, then enable it once installed
        require('nvim-treesitter').install(language):await(function() treesitter_try_attach(buf, language) end)
      else
        -- The parser may exist without being available from `nvim-treesitter`
        treesitter_try_attach(buf, language)
      end
    end,
  })

  -- [[ Treesitter textobjects ]]
  require('nvim-treesitter-textobjects').setup {
    select = { lookahead = true },
    move = { set_jumps = true },
  }

  local ts_select = require 'nvim-treesitter-textobjects.select'
  local ts_move = require 'nvim-treesitter-textobjects.move'
  local ts_swap = require 'nvim-treesitter-textobjects.swap'

  -- Select: `af` / `if` function, `ac` / `ic` class, `aa` / `ia` parameter
  local select_keys = {
    ['af'] = { '@function.outer', 'a [f]unction' },
    ['if'] = { '@function.inner', 'inside a [f]unction' },
    ['ac'] = { '@class.outer', 'a [c]lass' },
    ['ic'] = { '@class.inner', 'inside a [c]lass' },
    ['aa'] = { '@parameter.outer', 'a p[a]rameter' },
    ['ia'] = { '@parameter.inner', 'inside a p[a]rameter' },
  }
  for key, spec in pairs(select_keys) do
    vim.keymap.set({ 'x', 'o' }, key, function() ts_select.select_textobject(spec[1], 'textobjects') end, { desc = 'Select ' .. spec[2] })
  end

  -- Move: `]m` / `[m` function, `]]` / `[[` class, `]a` / `[a` parameter
  local move_keys = {
    goto_next_start = { [']m'] = '@function.outer', [']]'] = '@class.outer', [']a'] = '@parameter.outer' },
    goto_next_end = { [']M'] = '@function.outer', [']['] = '@class.outer' },
    goto_previous_start = { ['[m'] = '@function.outer', ['[['] = '@class.outer', ['[a'] = '@parameter.outer' },
    goto_previous_end = { ['[M'] = '@function.outer', ['[]'] = '@class.outer' },
  }
  for fn_name, keys in pairs(move_keys) do
    for key, query in pairs(keys) do
      vim.keymap.set({ 'n', 'x', 'o' }, key, function() ts_move[fn_name](query, 'textobjects') end, { desc = fn_name:gsub('_', ' ') .. ' ' .. query })
    end
  end

  -- Swap the parameter under the cursor with the next/previous one
  vim.keymap.set('n', '<leader>a', function() ts_swap.swap_next '@parameter.inner' end, { desc = 'Swap p[a]rameter with next' })
  vim.keymap.set('n', '<leader>A', function() ts_swap.swap_previous '@parameter.inner' end, { desc = 'Swap p[A]rameter with previous' })
end

-- ============================================================
-- SECTION 10: EXTRA MODULES
-- kickstart.plugins.* and your own custom.plugins.*
-- ============================================================
do
  require 'kickstart.plugins.debug'
  require 'kickstart.plugins.lint'
  require 'kickstart.plugins.autopairs'
  require 'kickstart.plugins.gitsigns' -- adds gitsigns recommended keymaps

  -- Loads every `lua/custom/plugins/*.lua` module
  require 'custom.plugins'
end

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
