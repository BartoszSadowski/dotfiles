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
-- #####         GENERAL KEYMAPS                #####
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
-- #####          GENERAL AUTOCOMMANDS          #####
-- ##################################################

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function() vim.hl.on_yank() end,
  desc = "Briefly highlight yanked text"
})

