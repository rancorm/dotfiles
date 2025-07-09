return {
  "nvim-treesitter/nvim-treesitter",
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = {
	"elixir",
	"lua",
	"python",
	"typescript",
	"css",
	"html",
	"json",
	"yaml",
	"javascript",
	"c",
	"rust",
	"go",
	"gomod",
	"gosum"
      },
      sync_install = false,
      auto_install = true,
      indent = {
	enable = true
      },
      highlight = {
	enable = true,
	additional_vim_regex_highlighting = { "markdown" }
      }
    })
  end
}
