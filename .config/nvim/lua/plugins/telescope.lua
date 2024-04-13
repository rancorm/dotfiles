return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.5",
  dependencies = {
    "nvim-lua/plenary.nvim"
  },
  config = function()
    require("telescope").setup {
      defaults = {
	prompt_prefix = "❯ ",
	selection_caret = "❯ ",
	layout_config = {
	  horizontal = {
	    preview_width = 0.55
	  }
	}
      }
    }

    api.nvim_set_keymap("n", "<leader>gf", "<cmd>Telescope git_files<cr>", { noremap = true })
    api.nvim_set_keymap("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { noremap = true })
  end
}
