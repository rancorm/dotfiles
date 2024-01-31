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
-- g.mapleader = " "

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

-- Functions
local function get_apple_interface_style()
    local handle = io.popen("defaults read -g AppleInterfaceStyle 2>/dev/null")
    local result = handle:read("*a")
    
    handle:close()

    return result
end

local function is_binary(binary_name)
    local command = "command -v " .. binary_name .. " > /dev/null 2>&1 || { echo >&2 'not found'; exit 1; }"
    local exit_code = os.execute(command)

    return exit_code == 0
end

-- Indentation
opt.tabstop = 8 -- Always 8 (see :h tabstop)
opt.softtabstop = 2 -- What you expecting
opt.shiftwidth = 2 -- What you expecting

-- Display
opt.number = true
opt.relativenumber = true
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
opt.titlestring = "❐ %t"
opt.titlelen = 70
opt.titleold = "%{ fnamemodify(getcwd(), :t) }"

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.wrapscan = true
opt.scrolloff = 4
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

--- Terminal key maps
km.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true })

-- Auto commands
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
  end,
})

