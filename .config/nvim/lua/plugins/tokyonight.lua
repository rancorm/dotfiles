return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  enabled = false,
  opts = {
    transparent = true,
    terminal_colors = true,
  },
  config = function()
    cmd([[colorscheme tokyonight]])
  end
}
