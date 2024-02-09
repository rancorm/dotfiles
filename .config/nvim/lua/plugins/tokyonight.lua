return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {},
  init = function()
    cmd([[colorscheme tokyonight]])
  end
}
