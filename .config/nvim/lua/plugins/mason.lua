return {
  "williamboman/mason.nvim",
  depends = "williamboman/mason-lspconfig.nvim",
  config = function ()
    require("mason").setup()
  end
}
