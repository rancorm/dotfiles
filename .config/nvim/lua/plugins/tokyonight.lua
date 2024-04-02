return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  enabled = false,
  opts = {
    transparent = true,
    terminal_colors = true,
  },
  init = function()
    cmd([[colorscheme tokyonight]])
  end
}
