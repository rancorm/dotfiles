-- 
-- Jonathan Cormier's Neovim config
--
--

-- Neovim version check
local neovim_version = vim.version()

if neovim_version.major >= 0 and neovim_version.minor < 8 then
    print(string.format("Config requires newer version of Neovim, current version is %d.%d.%d",
	neovim_version.major,
	neovim_version.minor,
	neovim_version.patch))

    return
end

-- Lazy package loader
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

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
	"lourenci/github-colors"
    },
    {
	"nvim-neo-tree/neo-tree.nvim", branch = "v3.x",
	dependencies = {
	    "nvim-lua/plenary.nvim",
	    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
	    "MunifTanjim/nui.nvim",
	    "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
	}
    },
--    {
--	"neoclide/coc.nvim", config = function()
--	    vim.cmd [[autocmd FileType * call coc#start()]]
--	end
--    }
}

-- Lazy plugin manager
require("lazy").setup(plugins, opts)

-- Telescope
local telescope = require("telescope.builtin")

-- Harpoon
local harpoon = require("harpoon")
harpoon:setup({})

vim.keymap.set("n", "<leader>a", function() harpoon:list():append() end)
vim.keymap.set("n", "<leader>c", function() harpoon:list():clear() end)
vim.keymap.set("n", "<leader>g", function() telescope:git_files() end)

vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<C-t>", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<C-n>", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<C-s>", function() harpoon:list():select(4) end)

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)

-- Terminal-mode keymaps
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true })

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
vim.keymap.set("n", "<C-e>", function() toggle_telescope(harpoon:list()) end,
    { desc = "Open harpoon window" })

-- Vim settings
vim.opt.tabstop = 8 -- Always 8 (see :h tabstop)
vim.opt.softtabstop = 4 -- What you expecting
vim.opt.shiftwidth = 4 -- What you expecting
-- vim.opt.expandtab = true -- Works without this

-- Theme
local has_defaults = is_binary("defaults")

-- Check for macOS defaults
if has_defaults then
    local apple_interface_style = get_apple_interface_style()

    -- Set theme based on system interface style
    if apple_interface_style == "Dark\n" then
	vim.cmd([[colorscheme elflord]])
    elseif apple_interface_style == "Light\n" then
	vim.cmd([[colorscheme github-colors]])
    end
else
    -- Set theme
    vim.cmd([[colorscheme elflord]])
end
