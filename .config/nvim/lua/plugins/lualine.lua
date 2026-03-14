return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
	  "nvim-tree/nvim-web-devicons",
	  "lucasadelino/jjtrack",
  },
  config = function()
	require("jjtrack").setup()

	local function jj_change()
		local s = vim.b.jjtrack_summary
		if not s then return "" end
		local prefix = s.change_id_prefix or ""
		local rest = s.change_id_rest or ""
		if prefix == "" then return "" end
		return prefix .. rest
	end

	require("lualine").setup {
		options = {
			theme = "zenwritten",
			globalstatus = true,
			extensions = {
				"neo-tree",
				"man"
			},
		},
		sections = {
			lualine_b = { jj_change, "diff", "diagnostics" }
		},
	}
  end,
}
