return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  init = function()
    require("lualine").setup {
      options = {
	theme = "iceberg",
	globalstatus = true,
	extensions = {
	  "neo-tree",
	  "man"
	}
      }
    }
  end
}
