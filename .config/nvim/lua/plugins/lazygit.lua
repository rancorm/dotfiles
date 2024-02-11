return {
  "kdheepak/lazygit.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim"
  },
  init = function()
    require("telescope").load_extension("lazygit")

    km.set("n", "<leader>gg", "<cmd>LazyGit<CR>", { noremap = true, silent = true })
  end
}
