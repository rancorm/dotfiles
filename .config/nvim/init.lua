--
-- Jonathan Cormier's Neovim config
--
--
local cmd, fn, opt = vim.cmd, vim.fn, vim.opt
local km, g = vim.keymap, vim.g

local neovim_version = vim.version()

if neovim_version.major >= 0 and neovim_version.minor < 8 then
    print(string.format("Config requires newer version of Neovim, current version is %d.%d.%d",
	neovim_version.major,
	neovim_version.minor,
	neovim_version.patch))

    return
end

-- Lazy package loader
local lazypath = fn.stdpath("data") .. "/lazy/lazy.nvim"

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

-- Lazy plugins
plugins = { 
  {
    "nvim-telescope/telescope.nvim", tag = "0.1.5",
    dependencies = {
      "nvim-lua/plenary.nvim"
    }
  },
  {
    "ThePrimeagen/harpoon", branch = "harpoon2",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim"
    }
  },
  {
    "nvim-treesitter/nvim-treesitter"
  },
  {	
    "projekt0n/github-nvim-theme"
  },
  {
    "nvim-neo-tree/neo-tree.nvim", branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", 
      "MunifTanjim/nui.nvim",
      "3rd/image.nvim", 
    }
  },
  {
    "github/copilot.vim"
  },
  {
    "coffebar/neovim-project",
    opts = {
      -- Define a list of project paths 
      projects = {
	"~/projects/*",
	"~/.config/*",
      },
    },
    init = function()
      -- Save the state of plugins in the session
      opt.sessionoptions:append("globals") 
    end,
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope.nvim", tag = "0.1.4" },
      { "Shatur/neovim-session-manager" },
    },
    lazy = false,
    priority = 100,
  },
  {
    "sbdchd/neoformat"
  }
}

-- Lazy plugin manager
require("lazy").setup(plugins, opts)

-- Telescope
local telescope = require("telescope.builtin")

-- Harpoon
local harpoon = require("harpoon")
harpoon:setup({})

km.set("n", "<leader>a", function() harpoon:list():append() end)
km.set("n", "<leader>c", function() harpoon:list():clear() end)
km.set("n", "<leader>g", function() telescope:git_files() end)

km.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

km.set("n", "<C-h>", function() harpoon:list():select(1) end)
km.set("n", "<C-t>", function() harpoon:list():select(2) end)
km.set("n", "<C-n>", function() harpoon:list():select(3) end)
km.set("n", "<C-s>", function() harpoon:list():select(4) end)

-- Toggle previous & next buffers stored within Harpoon list
km.set("n", "<C-S-P>", function() harpoon:list():prev() end)
km.set("n", "<C-S-N>", function() harpoon:list():next() end)

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

-- Telescope configuration
local conf = require("telescope.config").values
local function toggle_telescope(harpoon_files)
    local file_paths = {}
    for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
    end

    require("telescope.pickers").new({}, {
        prompt_title = "Harpoon",
        finder = require("telescope.finders").new_table({
            results = file_paths,
        }),
        previewer = conf.file_previewer({}),
        sorter = conf.generic_sorter({}),
    }):find()
end

-- Telescope Harpoon list toggle
km.set("n", "<C-e>", function() toggle_telescope(harpoon:list()) end,
    { desc = "Open harpoon window" })

-- Indentation
opt.tabstop = 8 -- Always 8 (see :h tabstop)
opt.softtabstop = 2 -- What you expecting
opt.shiftwidth = 2 -- What you expecting
-- opt.expandtab = true -- Works without this

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
-- Treat dash separated words as a word text object
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

-- Mappings
km.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true })

-- Colors and themes
local has_defaults = is_binary("defaults")

-- Check for macOS defaults
if has_defaults then
    local apple_interface_style = get_apple_interface_style()

    -- Set theme based on system interface style
    if apple_interface_style == "Dark\n" then
	cmd([[colorscheme github_dark_default]])
    elseif apple_interface_style == "Light\n" then
	cmd([[colorscheme github_light_default]])
    end
else
    -- Set theme
    cmd([[colorscheme github_dark_default]])
end
