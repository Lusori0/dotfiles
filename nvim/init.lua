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
  'echasnovski/mini.nvim',
  'nvim-treesitter/nvim-treesitter',
  -- 'williamboman/mason.nvim',
  -- 'williamboman/mason-lspconfig.nvim',
  -- 'neovim/nvim-lspconfig',
  'lewis6991/gitsigns.nvim',
  'folke/flash.nvim',
  'nvim-orgmode/orgmode',
  {'chomosuke/typst-preview.nvim', lazy = false, opts = {}},
  'stevearc/oil.nvim',
  'folke/snacks.nvim',
  'Wansmer/treesj',
  "ibhagwan/fzf-lua",
  "0xzhzh/fzf-org.nvim",
  "kdheepak/lazygit.nvim",
})

require('mini.basics').setup()

-- VIM SETTINGS --------------------------
local ok, _ = pcall(vim.cmd, 'colorscheme gruvbox')
vim.o.relativenumber  = true
vim.o.tabstop         = 2 -- How many spaces is a tab
vim.o.shiftwidth      = 2 -- How far to indent with <>
vim.o.expandtab       = true -- Use spaces for tab
vim.o.smartindent = true

-- VIM KEYMAPS ---------------------------
--copy paste cut
vim.keymap.set('v', '<leader>c', '"+y')
vim.keymap.set('v', '<leader>x', '"+d')
vim.keymap.set('n', '<leader>v', '"+p')
vim.keymap.set("x", "<leader>p", [["_dP]])

--splits
vim.keymap.set('n', '<leader>ö', '<C-W><C-L>')
vim.keymap.set('n', '<leader>l', '<C-W><C-K>')
vim.keymap.set('n', '<leader>k', '<C-W><C-J>')
vim.keymap.set('n', '<leader>j', '<C-W><C-H>')

-- resize splits
vim.keymap.set('n', '<leader>sh', ':split<CR>')
vim.keymap.set('n', '<leader>sv', ':vsplit<CR>')

-- buffer navigation
vim.keymap.set('n', '<leader>i', ':bnext<CR>')
vim.keymap.set('n', '<leader>u', ':bprevious<CR>')
vim.keymap.set('t', '<C-h>', '<C-\\><C-n>')

-- NVIMTREE -----------------------------
require("nvim-tree").setup()
vim.keymap.set('n', '<leader>t', ':NvimTreeFindFileToggle<CR>')

-- Snacks ------------------------------
require("snacks").setup({
  indent = {
    enabled = true,
    animate = {enabled = false},
    -- scope = {enabled = false},
  },
  toggle = {
    enabled = true
  },
})
vim.keymap.set('n', '<leader>q', Snacks.bufdelete.delete)

-- Oil ----------------------------------
require("oil").setup({keymaps = {["<Esc>"] = { "actions.parent", mode = "n" },}})
Snacks.toggle.new({
  name = "Oil",
  id = "toggle_oil",
  get = function()
    return vim.bo.filetype == 'oil'
  end,
  set = function(state)
    if state then
      vim.cmd('Oil')
    else
      require("oil.actions").close.callback()
    end
  end,
}):map("<leader>e")

-- TELESCOPE -----------------------------
require("fzf-lua").setup({
  keymap = {
    fzf = { ["ctrl-q"] = "select-all+accept"},
  },
  winopts = {
    fullscreen = true,
    border = "none",
    preview = { border = "none"},
  },
})
vim.keymap.set('n', '<leader>ff', FzfLua.files, {})
vim.keymap.set('n', '<leader>fs', FzfLua.live_grep_native, {})
vim.keymap.set('n', '<leader>fgs', FzfLua.git_status, {})

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

-- TREESJ -------------------------------
require('treesj').setup({use_default_keymaps=false})
vim.keymap.set('n', '<leader>sj', require('treesj').toggle)

-- GITSIGNS ------------------------------
require('gitsigns').setup()

-- TREESITTER ----------------------------
require'nvim-treesitter.configs'.setup {
  ensure_installed = {"c", "cpp", "lua", "query", "python", "go", "html", "css", "javascript", "puppet", "terraform", "yaml", "odin", "typst", "bash", "json", "helm"},
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


-- ORGMODE --------------------------------
require('orgmode').setup({
  org_agenda_files = '~/orgfiles/**/*',
  org_default_notes_file = '~/orgfiles/inbox.org',
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
  -- org_hide_emphasis_markers = true,
  org_startup_indented = true,
  org_tags_column = 0,
  mappings = {
    org = {
      org_refile = '<leader><leader>or'
    },
  },
})

require("fzf-org").setup()
vim.keymap.set('n', '<leader>of', require("fzf-org").orgmode, {})
vim.keymap.set('n', '<leader>or', require("fzf-org").refile_to_headline, {})

--- LazyGit
vim.keymap.set('n', '<leader>lg', ':LazyGit<CR>')

-- Custom functions and commands

-- Run kustomization
vim.api.nvim_create_user_command("Kust", function()
  local dir = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":p:h")
  local output = vim.fn.systemlist("kustomize build " .. vim.fn.shellescape(dir))

  vim.cmd("vsplit | enew")
  vim.bo.buftype, vim.bo.bufhidden, vim.bo.swapfile, vim.bo.filetype =
    "nofile", "wipe", false, "yaml"

  vim.api.nvim_buf_set_lines(0, 0, -1, false, output)
end, { desc = "Kustomize build" })
