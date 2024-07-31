return {
  "rancorm/nvim-aqua",
  lazy = false, -- Make sure to load this plugin during startup
  priority = 1000, -- Make sure to load this before all other start plugins
  version = "0.x",
  config = function()
    require("nvim-aqua").setup {
      light = function()
	vim.opt.background = "light"
      end,
      dark = function()
	vim.opt.background = "dark"
      end,
    }

    vim.notify("nvim-aqua loaded", "info")
  end
}
