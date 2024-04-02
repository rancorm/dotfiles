return {
  "rose-pine/neovim",
  lazy = false,
  priority = 1000,
  name = "rose-pine",
  init = function()
    require("rose-pine").setup({
      styles = {
	transparency = true
      }	
    })

    cmd("colorscheme rose-pine")
  end
}
