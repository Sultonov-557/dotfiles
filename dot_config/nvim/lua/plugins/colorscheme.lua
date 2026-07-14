-- Colorscheme — Catppuccin Mocha
return {
	{
		"catppuccin/nvim",
		lazy = false,
		name = "catppuccin",
		priority = 1000,
		opts = {
			flavour = "mocha",
			transparent_background = false,
			term_colors = true,
			dim_inactive = {
				enabled = false,
				shade = "dark",
				percentage = 0.15,
			},
			integrations = {
				cmp = true,
				gitsigns = true,
				nvimtree = true,
				treesitter = true,
				telescope = true,
				which_key = true,
				indent_blankline = {
					enabled = true,
					colored_indent_levels = false,
				},
				native_lsp = {
					enabled = true,
					virtual_text = {
						errors = { "italic" },
						hints = { "italic" },
						warnings = { "italic" },
						information = { "italic" },
					},
					underlines = {
						errors = { "underline" },
						hints = { "underline" },
						warnings = { "underline" },
						information = { "underline" },
					},
				},
				lsp_trouble = true,
				alpha = true,
				notify = true,
				mini = {
					enabled = true,
					indentscope_color = "mauve",
				},
				noice = true,
				symbols_outline = true,
				dap = {
					enabled = true,
					enable_ui = true,
				},
			},
			highlight_overrides = {
				mocha = {
					NormalFloat = { bg = "#1e1e2e" },
					FloatBorder = { bg = "#1e1e2e" },
					WinSeparator = { fg = "#45475a" },
					CursorLineNr = { fg = "#b4befe" },
					-- Search
					Search = { bg = "#b4befe", fg = "#1e1e2e" },
					IncSearch = { bg = "#cba6f7", fg = "#1e1e2e" },
					-- Pmenu
					PmenuSel = { bg = "#45475a", fg = "#b4befe" },
					-- Match paren
					MatchParen = { bg = "#45475a", fg = "#fab387" },
				},
			},
		},
		init = function()
			vim.cmd.colorscheme("catppuccin")
		end,
	},
}
