local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  'morhetz/gruvbox',
  'nvim-tree/nvim-tree.lua',
  'nvim-lua/plenary.nvim',
  'nvim-telescope/telescope.nvim',
  'echasnovski/mini.nvim',
  'nvim-treesitter/nvim-treesitter',
  -- 'williamboman/mason.nvim',
  -- 'williamboman/mason-lspconfig.nvim',
  -- 'neovim/nvim-lspconfig',
  'lewis6991/gitsigns.nvim',
  {'lukas-reineke/indent-blankline.nvim', main = "ibl", opts = {}},
  'folke/flash.nvim',
  'nvim-orgmode/orgmode',
  'nvim-orgmode/telescope-orgmode.nvim',
})

require('mini.basics').setup()

-- VIM SETTINGS --------------------------
local ok, _ = pcall(vim.cmd, 'colorscheme gruvbox')
vim.o.relativenumber  = true
vim.o.tabstop         = 2
vim.o.shiftwidth      = 2
vim.o.expandtab       = true
vim.o.smartindent     = true

-- VIM KEYMAPS ---------------------------
--copy paste cut
vim.keymap.set('v', '<leader>c', '"+y')
vim.keymap.set('v', '<leader>x', '"+d')
vim.keymap.set('n', '<leader>v', '"+p')

--splits
vim.keymap.set('n', '<leader>ö', '<C-W><C-L>')
vim.keymap.set('n', '<leader>l', '<C-W><C-K>')
vim.keymap.set('n', '<leader>k', '<C-W><C-J>')
vim.keymap.set('n', '<leader>j', '<C-W><C-H>')

-- resize splits
vim.keymap.set('n', '<leader>>', ':vertical res +15<CR>')
vim.keymap.set('n', '<leader><', ':vertical res -15<CR>')
vim.keymap.set('n', '<leader>sh', ':split<CR>')
vim.keymap.set('n', '<leader>sv', ':vsplit<CR>')

-- buffer navigation
vim.keymap.set('n', '<leader>i', ':bnext<CR>')
vim.keymap.set('n', '<leader>u', ':bprevious<CR>')
vim.keymap.set('n', '<leader>q', ':bd<CR>')
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')

-- NVIMTREE -----------------------------
require("nvim-tree").setup()
vim.keymap.set('n', '<leader>t', ':NvimTreeFindFileToggle<CR>')

-- TELESCOPE -----------------------------
local telescope = require('telescope')
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fgf', builtin.git_files, {})
vim.keymap.set('n', '<leader>fgs', builtin.git_status, {})
vim.keymap.set('n', '<leader>fgc', builtin.git_commits, {})
vim.keymap.set('n', '<leader>fgb', builtin.git_branches, {})
vim.keymap.set('n', '<leader>fs', builtin.live_grep, {})
vim.keymap.set('n', '<leader>ft', builtin.treesitter, {})

-- FLASH ---------------------------------
vim.keymap.set('n', '<leader>g', function() require("flash").jump() end, {})

-- MINI ----------------------------------
require('mini.surround').setup()
require('mini.icons').setup()
require('mini.tabline').setup()
require('mini.statusline').setup()
require('mini.trailspace').setup()
require('mini.completion').setup {
  delay = {
    completion = 0,
    info = 0,
    signature = 0,
  }
}

-- GITSIGNS ------------------------------
require('gitsigns').setup()

-- TREESITTER ----------------------------
require'nvim-treesitter.configs'.setup {
  ensure_installed = {"c", "cpp", "lua", "vim", "vimdoc", "query", "python", "go", "html", "css", "javascript", "puppet", "terraform", "yaml", "odin" },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}

-- LSP -----------------------------------
-- require("mason").setup()
-- require("mason-lspconfig").setup {
--   ensure_installed = {"ols"}
-- }
-- local lspconfig = require("lspconfig")
-- lspconfig.ols.setup {}

-- IBL ------------------------------------
require('ibl').setup{
  indent = {highlight = {"NonText", "NonText"},},
  scope = {enabled=false},
}

-- ORGMODE --------------------------------
require('orgmode').setup({
  org_agenda_files = '~/orgfiles/**/*',
  org_default_notes_file = '~/orgfiles/refile.org',
  org_todo_keywords = {'TODO', 'WAIT', 'HOLD', '|', 'DONE', 'CANC'},
  org_todo_keyword_faces = {
    TODO = ':foreground #282828 :background #cc241d :weight bold',
    WAIT = ':foreground #282828 :background #fabd2f :weight bold',
    HOLD = ':foreground #282828 :background #83a598 :weight bold',
    DONE = ':foreground #282828 :background #b8bb26 :weight bold',
    CANC = ':foreground #282828 :background #d3869b :weight bold',
  },
  org_agenda_sorting_strategy ={
    todo = {'todo-state-up', 'priority-down'},
    tags = {'todo-state-up', 'priority-down'},
  },
  win_split_mode = 'vertical',
  org_log_into_drawer = 'LOGBOOK',
  org_startup_folded = 'content',
  org_hide_leading_stars = true,
  org_hide_emphasis_markers = true,
  org_startup_indented = true,
  org_tags_column = 0,
  mappings = {
    org = {
      org_refile = '<leader><leader>or'
    },
  },
})

vim.keymap.set('n', '<leader>or', require("telescope").extensions.orgmode.refile_heading)
vim.keymap.set('n', '<leader>of', telescope.extensions.orgmode.search_headings)

-- Fix bug of telescope-orgmode.nvim where files have folds on opening
vim.o.foldlevelstart  = 99
vim.o.conceallevel    = 2
