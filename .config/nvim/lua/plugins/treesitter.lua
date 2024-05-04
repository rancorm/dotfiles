return {
  "nvim-treesitter/nvim-treesitter",
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = {
	"elixir",
	"lua",
	"python",
	"ruby",
	"typescript",
	"css",
	"html",
	"json",
	"yaml",
	"javascript",
	"c",
	"heex",
	"rust"
      },
      highlight = {
	enable = true
      }
    })
  end
}
