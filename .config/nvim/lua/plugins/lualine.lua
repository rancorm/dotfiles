return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("lualine").setup {
      options = {
	theme = "zenwritten",
	globalstatus = true,
	extensions = {
	  "neo-tree",
	  "man"
	}
      }
    }
  end
}
