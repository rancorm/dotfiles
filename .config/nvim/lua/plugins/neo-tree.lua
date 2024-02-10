return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", 
    "MunifTanjim/nui.nvim",
    "3rd/image.nvim"
  },
  init = function()
    km.set("n", "<leader>e", ":Neotree toggle<CR>", { silent = true })
  end
}
