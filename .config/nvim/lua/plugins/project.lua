return {
  "coffebar/neovim-project",
  opts = {
    -- Define a list of project paths 
    projects = {
      "~/projects/*",
      "~/.config/*",
    },
  },
  config = function()
    -- Save the state of plugins in the session
    opt.sessionoptions:append("globals") 
  end,
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    { "nvim-telescope/telescope.nvim", tag = "0.1.4" },
    { "Shatur/neovim-session-manager" },
  },
  lazy = false,
  priority = 100
}
