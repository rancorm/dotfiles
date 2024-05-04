return {
  "rose-pine/neovim",
  lazy = false,
  priority = 1000,
  name = "rose-pine",
  config = function()
    require("rose-pine").setup({
      styles = {
	transparency = true
      }	
    })

    cmd("colorscheme rose-pine")
  end
}
