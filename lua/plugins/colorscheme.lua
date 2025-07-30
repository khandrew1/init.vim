-- return { "EdenEast/nightfox.nvim" }

-- return {
--     {
--         "folke/tokyonight.nvim",
--         lazy = false,
--         priority = 1000,
--         opts = {},
--     }
-- }

return {
	"scottmckendry/cyberdream.nvim",
	lazy = false,
	priority = 1000,
	opts = {
		transparent = false,
		italic_comments = false,
		hide_fillchars = false,
		borderless_telescope = { border = false, style = "nvchad" },
		terminal_colors = false,
		variant = "dark",
	},
	config = function(_, opts)
		require("cyberdream").setup(opts)
		vim.cmd("colorscheme cyberdream")
	end,
}
