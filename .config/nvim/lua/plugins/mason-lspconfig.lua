return {
  "williamboman/mason-lspconfig.nvim",
  dependencies = {
    "neovim/nvim-lspconfig"
  },
  config = function()
    require("mason-lspconfig").setup()
  end,
}
