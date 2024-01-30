return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim"
  },
  config = function()
    require("harpoon").setup({})

    local conf = require("telescope.config").values
    local function toggle_telescope(harpoon_files)
      local file_paths = {}
      
      for _, item in ipairs(harpoon_files.items) do
	table.insert(file_paths, item.value)
      end

      require("telescope.pickers").new({}, {
	prompt_title = "Harpoon",
	finder = require("telescope.finders").new_table({
	  results = file_paths
	}),
	sorter = conf.generic_sorter({}),
	previewer = conf.file_previewer({})
      }):find()
    end
    
    -- Key maps
    km.set("n", "<leader>a", function() harpoon:list():append() end)
    km.set("n", "<leader>c", function() harpoon:list():clear() end)
    km.set("n", "<leader>g", function() telescope:git_files() end)

    km.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

    km.set("n", "<C-h>", function() harpoon:list():select(1) end)
    km.set("n", "<C-t>", function() harpoon:list():select(2) end)
    km.set("n", "<C-n>", function() harpoon:list():select(3) end)
    km.set("n", "<C-s>", function() harpoon:list():select(4) end)

    --- Toggle previous & next buffers stored within Harpoon list
    km.set("n", "<C-S-P>", function() harpoon:list():prev() end)
    km.set("n", "<C-S-N>", function() harpoon:list():next() end)

    --- Toggle telescope window with Harpoon list
    km.set("n", "<C-e>", function()
      toggle_telescope(harpoon:list())
    end, { desc = "Open harpoon window" })
  end
}
