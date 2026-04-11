-- ##################################################
-- #####          GENERAL CONFIG                #####
-- ##################################################

-- Set <space> as the leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- Line numbering
vim.opt.number = true
vim.opt.relativenumber = true

-- Disable mouse
vim.opt.mouse = ''

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Sets how neovim will display certain whitespace characters in the editor.
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- Do not close folds by default
vim.o.foldlevelstart = 99

-- ##################################################
-- #####          GENERAL AUTOCOMMANDS          #####
-- ##################################################

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function() vim.hl.on_yank() end,
  desc = 'Briefly highlight yanked text',
})

-- ##################################################
-- #####              FILE TYPES                #####
-- ##################################################

-- Set custom file mappings
vim.filetype.add {
  extension = {
    Jenkinsfile = 'groovy',
    jenkinsfile = 'groovy',
    flow = 'javascript',
  },
}

-- ##################################################
-- #####            GENERAL KEYMAPS             #####
-- ##################################################

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [q]uickfix list' })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Register handling
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>y', '"+y', { silent = true, desc = '[Y]ank to clipboard' })
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>p', '"+p', { silent = true, desc = '[P]aste from clipboard' })

-- Handling buffer metadata
vim.keymap.set({ 'n' }, '<leader>bfr', function()
  local path = vim.api.nvim_buf_get_name(0)
  print(path)
  vim.fn.setreg('+', path)
end, { desc = '[B]uffer [F]ilename [R]ead' })
vim.keymap.set('n', '<leader>bl', ':e<CR>', { desc = '[B]uffer [L]oad' })

-- ##################################################
-- #####                 PLUGINS                #####
-- ##################################################

local gh = function(x) return 'https://github.com/' .. x end

-- ##################################################
-- #####                UTILITY                 #####
-- ##################################################

vim.pack.add { gh 'folke/snacks.nvim' }
local Snacks = require 'snacks'

vim.pack.add { gh 'echasnovski/mini.nvim' }

-- **************************************************
-- *****               AUTOPAIRS                *****
-- **************************************************

require('mini.pairs').setup()

-- **************************************************
-- *****             TEXT OBJECTS               *****
-- **************************************************

-- Examples:
--  - va)  - [V]isually select [A]round [)]paren
--  - yinq - [Y]ank [I]nside [N]ext [Q]uote
--  - ci'  - [C]hange [I]nside [']quote
require('mini.ai').setup { n_lines = 500 }

-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
-- - sd'   - [S]urround [D]elete [']quotes
-- - sr)'  - [S]urround [R]eplace [)] [']
require('mini.surround').setup()

-- **************************************************
-- *****               KEY MAPS                 *****
-- **************************************************

vim.pack.add { gh 'folke/which-key.nvim' }

local whichKey = require 'which-key'
whichKey.setup()

-- Document previous behaviours
whichKey.add { { '<leader>b', group = '[B]uffer' }, { '<leader>bf', group = '[B]uffer [F]ile' } }

-- ##################################################
-- #####                 VISUALS                #####
-- ##################################################

-- **************************************************
-- *****               COLORSCHEME              *****
-- **************************************************

vim.pack.add { gh 'catppuccin/nvim' }

require('catppuccin').setup {}

-- vim.opt.termguicolors = true
vim.cmd.colorscheme 'catppuccin-frappe'

-- Configure highlights
vim.cmd.hi 'Comment gui=none'

-- **************************************************
-- *****               STATUSLINE               *****
-- **************************************************

local statusline = require 'mini.statusline'
statusline.setup { use_icons = vim.g.have_nerd_font }

-- ##################################################
-- #####                 TOOLS                  #####
-- ##################################################

-- **************************************************
-- *****                  GIT                   *****
-- **************************************************

vim.pack.add { gh 'lewis6991/gitsigns.nvim' }

require('gitsigns').setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
  on_attach = function(bufnr)
    local gitsigns = require 'gitsigns'

    local function map(mode, keys, command, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, keys, command, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then
        vim.cmd.normal { ']c', bang = true }
      else
        gitsigns.nav_hunk 'next'
      end
    end, { desc = 'Jump to next git [c]hange' })

    map('n', '[c', function()
      if vim.wo.diff then
        vim.cmd.normal { '[c', bang = true }
      else
        gitsigns.nav_hunk 'prev'
      end
    end, { desc = 'Jump to previous git [c]hange' })

    -- Actions
    map('v', '<leader>gs', function() gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { desc = '[g]it hunk [s]tage' })
    map('n', '<leader>gs', gitsigns.stage_hunk, { desc = '[g]it hunk [s]tage' })

    map('v', '<leader>gr', function() gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { desc = '[g]it hunk [r]eset' })
    map('n', '<leader>gr', gitsigns.reset_hunk, { desc = '[g]it hunk [r]eset' })

    map('n', '<leader>gS', gitsigns.stage_buffer, { desc = 'git [S]tage buffer' })
    map('n', '<leader>gu', gitsigns.undo_stage_hunk, { desc = 'git [u]ndo stage hunk' })
    map('n', '<leader>gR', gitsigns.reset_buffer, { desc = 'git [R]eset buffer' })
    map('n', '<leader>gp', gitsigns.preview_hunk, { desc = 'git [p]review hunk' })
    map('n', '<leader>gb', gitsigns.blame_line, { desc = 'git [b]lame line' })
    map('n', '<leader>gd', gitsigns.diffthis, { desc = 'git [d]iff against index' })
    map('n', '<leader>gD', function() gitsigns.diffthis '@' end, { desc = 'git [D]iff against last commit' })

    -- Toggles
    map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = '[T]oggle git show [b]lame line' })
    map('n', '<leader>tD', gitsigns.toggle_deleted, { desc = '[T]oggle git show [D]eleted' })
  end,
}

whichKey.add { {
  { '<leader>g', group = '[G]it Hunk', mode = { 'n', 'v' } },
  { '<leader>t', group = '[T]oggle' },
} }

-- ##################################################
-- #####              NAVIGATION                #####
-- ##################################################

-- Handle file explorer
vim.keymap.set('n', '<leader>e', ':Explore<CR>', { desc = 'Open file [e]xplorer' })

-- **************************************************
-- *****             FUZZY FINDER               *****
-- **************************************************

-- Setup snacks picker
Snacks.picker.setup {}

-- Exact picker configs
local bufferPicker = function()
  Snacks.picker.buffers {
    win = {
      input = {
        keys = {
          ['<C-d>'] = { 'bufdelete', mode = { 'n', 'i' } },
        },
      },
      list = { keys = { ['dd'] = 'bufdelete' } },
    },
  }
end

-- Setup keymaps
vim.keymap.set('n', '<leader><leader>', bufferPicker, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>sf', function() Snacks.picker.files { excludes = { 'dist', 'build' } } end, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sg', function() Snacks.picker.grep() end, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sr', function() Snacks.picker.resume() end, { desc = '[S]earch [R]esume' })
vim.keymap.set('n', '<leader>sc', function() Snacks.picker.git_status() end, { desc = '[S]earch through [C]hanges' })

whichKey.add {
  { '<leader>s', group = '[S]earch' },
}

-- ##################################################
-- #####               LANGUAGES                #####
-- ##################################################

-- **************************************************
-- *****               TREESITTER               *****
-- **************************************************

-- Manage TreeSitter definitions

vim.pack.add { {
  src = gh 'nvim-treesitter/nvim-treesitter',
  version = 'main',
} }

-- Install defaults
local defaultTreesitterParsers = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' }
require('nvim-treesitter').install(defaultTreesitterParsers)

-- Setup languages

---@param buf integer
---@param language string
local function treesitter_try_attach(buf, language)
  -- check if parser exists and load it
  if not vim.treesitter.language.add(language) then return end

  -- enables syntax highlighting and other treesitter features
  vim.treesitter.start(buf, language)

  -- enables treesitter based folds
  -- for more info on folds see `:help folds`
  vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
  vim.wo.foldmethod = 'expr'

  -- enables treesitter based indentation
  vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
end

local available_parsers = require('nvim-treesitter').get_available()
local installed_parsers = require('nvim-treesitter').get_installed 'parsers'

vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    local buf, filetype = args.buf, args.match

    local language = vim.treesitter.language.get_lang(filetype)
    if not language then return end

    if vim.tbl_contains(installed_parsers, language) then
      -- enable the parser if it is installed
      treesitter_try_attach(buf, language)
    elseif vim.tbl_contains(available_parsers, language) then
      -- if a parser is available in `nvim-treesitter` auto install it, and enable it after the installation is done
      require('nvim-treesitter').install(language):await(function() treesitter_try_attach(buf, language) end)
    else
      -- try to enable treesitter features in case the parser exists but is not available from `nvim-treesitter`
      treesitter_try_attach(buf, language)
    end
  end,
})

-- Show treestiter context for long methods
vim.pack.add { gh 'nvim-treesitter/nvim-treesitter-context' }

-- **************************************************
-- *****              AUTOCOMPLETE              *****
-- **************************************************

-- Snippets
vim.pack.add { gh 'rafamadriz/friendly-snippets' }

-- Completion engine
vim.pack.add { {
  src = gh 'saghen/blink.cmp',
  version = 'v1',
} }

require('blink.cmp').setup()

-- **************************************************
-- *****                   LSP                  *****
-- **************************************************

-- Install Mason for LSP handling
vim.pack.add { gh 'mason-org/mason.nvim' }

require('mason').setup()

-- Remove unused default mappings
vim.keymap.del('n', 'grn')
vim.keymap.del('n', 'gra')
vim.keymap.del('n', 'grr')
vim.keymap.del('n', 'gri')

vim.api.nvim_create_user_command('LspInfo', 'checkhealth vim.lsp', {})

vim.lsp.config('*', {
  on_attach = function(client, bufnr)
    print 'lsp attached'
    -- Navigation
    vim.keymap.set('n', 'gd', function() Snacks.picker.lsp_definitions() end, { desc = '[G]oto [D]efinition' })
    vim.keymap.set('n', 'gr', function() Snacks.picker.lsp_references() end, { desc = '[G]oto [R]eferences' })

    -- Actions
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = '[R]e[n]ame' })
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = '[C]ode [A]ction' })

    client.server_capabilities.semnticTokensProvider = vim.NIL
  end,
})

whichKey.add {
  { '<leader>c', group = '[C]ode' },
  { '<leader>r', group = '[R]ename' },
}

-- Map servers to exes and enable
local lsp_servers = {
  bashls = 'bash-language-server',
  cssls = 'vscode-css-language-server',
  cucumber_language_server = 'cucumber-language-server',
  eslint = 'vscode-eslint-language-server',
  gradle_ls = 'gradle-language-server',
  groovyls = 'groovy-language-server',
  intelephense = 'intelephense',
  lua_ls = 'lua-language-server',
  ts_ls = 'typescript-language-server',
}

local function enableLSPs()
  for server_name, lsp_executable in pairs(lsp_servers) do
    if vim.fn.executable(lsp_executable) == 1 then vim.lsp.enable { server_name } end
  end
end
enableLSPs()

-- **************************************************
-- *****               AUTOFORMAT               *****
-- **************************************************

vim.pack.add { gh 'stevearc/conform.nvim' }

require('conform').setup {
  notify_on_error = false,
  format_on_save = function(bufnr)
    -- Disable "format_on_save lsp_fallback" for languages that don't
    -- have a well standardized coding style. You can add additional
    -- languages here or re-enable it for the disabled ones.
    local disable_filetypes = { c = true, cpp = true, cucumber = true }
    return {
      timeout_ms = 500,
      lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
    }
  end,
  formatters_by_ft = {
    lua = { 'stylua' },
    javascript = { 'prettierd', 'prettier', stop_after_first = true },
  },
}
