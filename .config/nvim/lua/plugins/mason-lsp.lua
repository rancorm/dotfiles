return {
  "williamboman/mason-lspconfig.nvim",
  depends = { "neovim/nvim-lspconfig" },
  config = function()
    require("mason-lspconfig").setup()
  end,
}
