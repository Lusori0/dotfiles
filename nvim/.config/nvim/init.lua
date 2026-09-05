vim.api.nvim_create_autocmd('PackChanged', { callback = function(ev)
  local name, kind = ev.data.spec.name, ev.data.kind
  if name == 'nvim-treesitter' and kind == 'update' then
    if not ev.data.active then vim.cmd.packadd('nvim-treesitter') end
    vim.cmd('TSUpdate')
  end
end })

vim.pack.add({
  'https://github.com/morhetz/gruvbox',
  'https://github.com/nvim-tree/nvim-tree.lua',
  'https://github.com/echasnovski/mini.nvim',
  'https://github.com/nvim-treesitter/nvim-treesitter',
  'https://github.com/lewis6991/gitsigns.nvim',
  'https://github.com/nvim-orgmode/orgmode',
  'https://github.com/chomosuke/typst-preview.nvim',
  'https://github.com/stevearc/oil.nvim',
  'https://github.com/folke/snacks.nvim',
  'https://github.com/Wansmer/treesj',
  "https://github.com/ibhagwan/fzf-lua",
  "https://github.com/0xzhzh/fzf-org.nvim",
  'https://github.com/folke/flash.nvim',
})

require('mini.basics').setup()

-- VIM SETTINGS --------------------------
pcall(vim.cmd, 'colorscheme gruvbox')
vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })
vim.opt.relativenumber  = true
vim.opt.tabstop         = 2    -- How many spaces is a tab
vim.opt.shiftwidth      = 2    -- How far to indent with <>
vim.opt.expandtab       = true -- Use spaces for tab
vim.opt.smartindent     = true
vim.opt.list            = true
vim.opt.listchars       = "tab:><"
vim.opt.colorcolumn     = "80"

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
vim.keymap.set('t', '<ESC>', '<C-\\><C-n>')

-- NVIMTREE -----------------------------
require("nvim-tree").setup()
vim.keymap.set('n', '<leader>t', ':NvimTreeFindFileToggle<CR>')

-- TREESITTER --------------------------
local ts = require("nvim-treesitter")

local languages = { "c", "cpp", "lua", "query", "python", "go", "html", "css", "javascript", "typescript", "puppet", "terraform", "yaml", "odin", "typst", "bash", "json", "helm", "gleam" }
ts.setup()
ts.install(languages)

vim.api.nvim_create_autocmd("FileType", {
  pattern = languages,
  callback = function()
    vim.treesitter.start()
  end,
})

-- SNACKS ------------------------------
require("snacks").setup({
  indent = {enabled = true, animate = {enabled = false}},
  lazygit = {configure = false, win = {backdrop = false}}
})
vim.keymap.set('n', '<leader>q', function() Snacks.bufdelete.delete() end)
vim.keymap.set('n', '<leader>lg', function() Snacks.lazygit.open() end)

-- Oil ----------------------------------
local oil = require("oil")
oil.setup({keymaps = {["<Esc>"] = { "actions.parent", mode = "n" },}, float = {border="rounded"}})
vim.keymap.set("n", "<leader>e", function() oil.toggle_float() end)

-- TELESCOPE -----------------------------
fzf_lua = require("fzf-lua")
fzf_lua.setup({
  winopts = {
    fullscreen = true,
    border = "none",
    preview = { border = "none"},
  },
})
vim.keymap.set('n', '<leader>ff', function()
  fzf_lua.files({ rg_opts = "--color=never --files --hidden --glob '!.*/*'" })
end)

vim.keymap.set('n', '<leader>fs', function()
  fzf_lua.live_grep_native({ rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 --hidden --glob '!.*/*' -e" })
end)
-- MINI ----------------------------------
require('mini.ai').setup()
require('mini.surround').setup()
require('mini.icons').setup()
require('mini.tabline').setup()
require('mini.statusline').setup()
require('mini.trailspace').setup()
require('mini.align').setup({mappings = {start = '<leader>a'}})
require('mini.completion').setup {
  delay = {
    completion = 0,
    info = 0,
    signature = 0,
  }
}

-- FLASH -------------------------------
local flash = require("flash")
flash.setup({modes = {char = {keys = {}}}})
vim.keymap.set({ "n", "x", "o" }, "f", function() flash.jump() end)

-- TREESJ -------------------------------
local treesj = require('treesj')
treesj.setup({use_default_keymaps=false, max_join_length=math.huge})
vim.keymap.set('n', '<leader>sj', treesj.toggle)

-- GITSIGNS ------------------------------
require('gitsigns').setup()

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

local fzf_org = require("fzf-org")
fzf_org.setup()
vim.keymap.set('n', '<leader>of', fzf_org.orgmode, {})
vim.keymap.set('n', '<leader>or', fzf_org.refile_to_headline, {})

-- Run kustomization
vim.api.nvim_create_user_command("Kust", function()
  local dir = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":p:h")
  local output = vim.fn.systemlist("kustomize build " .. vim.fn.shellescape(dir))

  vim.cmd("vsplit | enew")
  vim.bo.buftype, vim.bo.bufhidden, vim.bo.swapfile, vim.bo.filetype =
    "nofile", "wipe", false, "yaml"

  vim.api.nvim_buf_set_lines(0, 0, -1, false, output)
end, { desc = "Kustomize build" })
