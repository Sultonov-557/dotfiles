-- Colorscheme — everforest with Gruvbox accent overrides
return {
	{
		"sainnhe/gruvbox-material",
		lazy = false,
		priority = 1000,
		init = function()
			vim.g.everforest_background = "dark"
			vim.g.everforest_better_performance = 1
			vim.cmd.colorscheme("gruvbox-material")
		end,
		config = function()
			-- Gruvbox-inspired highlight overrides applied after colorscheme loads
			vim.schedule(function()
				local hl = vim.api.nvim_set_hl
				hl(0, "Normal", { bg = "#1d2021" })
				hl(0, "NormalFloat", { bg = "#282828" })
				hl(0, "NormalNC", { bg = "#1d2021" })
				hl(0, "SignColumn", { bg = "#1d2021" })
				hl(0, "LineNr", { fg = "#504945" })
				hl(0, "CursorLineNr", { fg = "#ebdbb2" })
				hl(0, "CursorLine", { bg = "#3c3836" })
				hl(0, "Visual", { bg = "#504945" })
				hl(0, "Search", { bg = "#b8bb26", fg = "#1d2021" })
				hl(0, "IncSearch", { bg = "#fabd2f", fg = "#1d2021" })
				hl(0, "Pmenu", { bg = "#3c3836", fg = "#ebdbb2" })
				hl(0, "PmenuSel", { bg = "#504945", fg = "#b8bb26" })
				hl(0, "WinSeparator", { fg = "#504945", bg = "#1d2021" })
				hl(0, "FloatBorder", { fg = "#665c54", bg = "#282828" })
				hl(0, "Title", { fg = "#b8bb26", bold = true })
				hl(0, "MatchParen", { bg = "#665c54", fg = "#fe8019" })
			end)
		end,
	},
}
