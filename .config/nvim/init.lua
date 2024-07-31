--
-- Jonathan Cormier's Neovim config
--

-- Aliases to reduce syntax noise
cmd, fn, opt = vim.cmd, vim.fn, vim.opt
km, g, api = vim.keymap, vim.g, vim.api
bo = vim.bo

-- Neovim version check
local nv_ver = vim.version()

if nv_ver.major >= 0 and nv_ver.minor < 8 then
  local msg = string.format("Config requires newer version of Neovim, current version is %d.%d.%d",
	nv_ver.major,
	nv_ver.minor,
	nv_ver.patch)
  print(msg)
  return
end

-- Lazy package loader
local lazypath = fn.stdpath("data") .. "/lazy/lazy.nvim"
g.mapleader = " "
g.maplocalleader = " "

if not vim.loop.fs_stat(lazypath) then
  fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

opt.rtp:prepend(lazypath)

-- Plugins
require("lazy").setup("plugins")

-- Indentation
opt.tabstop = 8 -- Always 8 (see :h tabstop)
opt.softtabstop = 2 -- What you expecting
opt.shiftwidth = 2 -- What you expecting
opt.smartindent = true
opt.shiftround = true

-- Display
opt.termguicolors = true
opt.number = true
opt.relativenumber = true
--- Cursor line
opt.cursorline = true -- Highlight current line
opt.numberwidth = 2
-- opt.signcolumn = "yes:1"
opt.laststatus = 2
opt.wrap = true
opt.linebreak = true -- Wrap at word boundaries 
opt.showmode = false
opt.emoji = false
opt.list = false -- Hide whitespace
opt.listchars = {
  tab = "» ",
  trail = "·",
  extends = "…",
  precedes = "…",
  nbsp = "␣",
  eol = "↲",
}

-- Title
opt.title = true
opt.titlestring = "%t"
opt.titlelen = 70
opt.titleold = "%{ fnamemodify(getcwd(), :t) }"

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.wrapscan = true
opt.scrolloff = 10
opt.showmatch = true

-- Motions
--- Treat dash separated words as a word text object
opt.iskeyword:prepend { "-" }

-- Window splits and buffers
opt.hidden = true
opt.splitbelow = true
opt.splitright = true
opt.fillchars = {
  vert = '│',
  fold = ' ',
  diff = '╱', -- alternatives: ⣿ ░
  msgsep = '‾',
  foldopen = '▾',
  foldsep = '│',
  foldclose = '▸',
}

-- Wildcard and file globbing
opt.wildignorecase = true
opt.wildcharm = 26 -- <C-z>
opt.wildignore = {
  "*.aux,*.out,*.toc",
  "*.o,*.obj,*.dll,*.jar,*.pyc,__pycache__,*.rbc,*.class",
  -- Media
  "*.ai,*.bmp,*.gif,*.ico,*.jpg,*.jpeg,*.png,*.psd,*.webp",
  "*.avi,*.m4a,*.mp3,*.oga,*.ogg,*.wav,*.webm",
  "*.eot,*.otf,*.ttf,*.woff",
  "*.doc,*.pdf",
  -- Archives
  "*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz",
  -- Temporary
  "*.*~,*~ ",
  "*.swp,.lock,.DS_Store,._*,tags.lock",
  -- Version control
  ".git,.svn",
}
opt.wildoptions = "pum"
opt.pumblend = 7
opt.pumheight = 20

-- Mouse
opt.mouse = "a"
opt.mousefocus = true
-- opt.mousemodel = "extend"

-- Timings
opt.updatetime = 100
opt.timeout = true
opt.timeoutlen = 1000
opt.ttimeoutlen = 10

-- Netrw
g.netrw_banner = 0
g.netrw_liststyle = 3
g.netrw_browse_split = 2
g.netrw_altv = 1

-- Terminal
opt.termguicolors = true

-- Toggle see whitespace characters like: eol, space, ...
opt.lcs = "tab:>-,eol:$,nbsp:X,trail:#"

-- Keymaps
--- Window key maps
km.set("n", "<C-h>", "<C-w>h")
km.set("n", "<C-j>", "<C-w>j")
km.set("n", "<C-k>", "<C-w>k")
km.set("n", "<C-l>", "<C-w>l")

km.set("n", "<F6>", ":set list!<cr>")

km.set("n", "<S-H>", "_")
km.set("n", "<S-L>", "$")

--- Terminal key maps
km.set("t", "<C-h>", "<cmd>wincmd h<CR>")
km.set("t", "<C-j>", "<cmd>wincmd j<CR>")
km.set("t", "<C-k>", "<cmd>wincmd k<CR>")
km.set("t", "<C-l>", "<cmd>wincmd l<CR>")

km.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true })

km.set("n", "<leader>d", "diw")

-- Utils
opt.sessionoptions = {
  "blank",
  "buffers",
  "curdir",
  "folds",
  "help",
  "options",
  "tabpages",
  "winsize",
  "resize",
  "winpos",
  "terminal"
}

opt.complete:prepend { "kspell" }
opt.completeopt = { "menu", "menuone", "noselect" }
opt.clipboard = "unnamedplus"
opt.inccommand = "nosplit"

-- Autocommands
--- Resize splits when resizing
api.nvim_create_autocmd("VimResized", { command = "horizontal wincmd =" })

--- Restore cursor position
local ignore_filetype = { "gitcommit", "gitrebase" }
local ignore_buftype = { "quickfix", "nofile", "help" }

api.nvim_create_autocmd("BufReadPost", {
  desc = "Restore cursor to last known position",
  group = api.nvim_create_augroup("restore_cursor", { clear = true }),
  callback = function()
    if vim.tbl_contains(ignore_filetype, bo.filetype) then
      return
    end

    if vim.tbl_contains(ignore_buftype, bo.buftype) then
      return
    end

    local row, col = unpack(api.nvim_buf_get_mark(0, '"'))

    if row > 0 and row <= api.nvim_buf_line_count(0) then
      api.nvim_win_set_cursor(0, { row, col })

      if api.nvim_eval "foldclosed(\'.\')" ~= -1 then
        api.nvim_input "zv"
      end
    end
  end
})

--- Highlight yanked text briefly  
api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight yanked text",
  callback = function()
    vim.highlight.on_yank {
      higroup = "Search",
      timeout = 250,
      on_visual = true
    }
  end
})

-- Commands

--- Search recursively with ripgrep
--- @param pattern string
--- @param depth number
function cgrep(pattern, depth)
  local grep_parts = { "rg", }

  if depth then
    table.insert(grep_parts, "--max-depth")
    table.insert(grep_parts, tostring(depth))
  end

  table.insert(grep_parts, "--vimgrep")
  table.insert(grep_parts, pattern)
  table.insert(grep_parts, ".")

  local grep_cmd = table.concat(grep_parts, " ")
  local grep_open = io.popen(grep_cmd, "r")
  local result = grep_open:read("*all")
  local lines = {}

  grep_open:close()

  for line in string.gmatch(result, "(.-)\n") do
    table.insert(lines, line)
  end

  fn.setqflist({},
    " ", {
      title = "Search results",
      lines = lines,
    }
  )

  cmd("copen")
end

cmd("command! -nargs=* Cgrep :lua cgrep(<f-args>)")
cmd("command! -nargs=* Cg :Cgrep <args>")
