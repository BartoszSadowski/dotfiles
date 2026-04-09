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

-- Handle file explorer
vim.keymap.set('n', '<leader>e', ':Explore<CR>', { desc = 'Open file [e]xplorer' })

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
    print 'attached'
    -- Navigation
    -- Enable once telescope is installed
    -- vim.keymap.set('n', 'gd', require('telescope.builtin').lsp_definitions, { desc = '[G]oto [D]efinition' })
    -- vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, { desc = '[G]oto [R]eferences' })

    -- Actions
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = '[R]e[n]ame' })
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = '[C]ode [A]ction' })

    client.server_capabilities.semnticTokensProvider = vim.NIL
  end,
})

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
