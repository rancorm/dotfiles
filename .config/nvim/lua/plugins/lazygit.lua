return {
  "kdheepak/lazygit.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim"
  },
  config = function()
    require("telescope").load_extension("lazygit")

    km.set("n", "<leader>lg", "<cmd>LazyGit<CR>", { noremap = true, silent = true })
  end
}
