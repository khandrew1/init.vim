return {
	{
		"mason-org/mason.nvim",
		lazy = false,
		opts = {
			PATH = "prepend",
		},
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			vim.lsp.config("*", {
				capabilities = {
					textDocument = {
						semanticTokens = {
							multilineTokenSupport = true,
						},
					},
				},
				root_markers = { ".git" },
			})

			vim.lsp.handlers["client/registerCapability"] = (function(overridden)
				return function(err, res, ctx)
					local result = overridden(err, res, ctx)
					local client = vim.lsp.get_client_by_id(ctx.client_id)
					local buffer = vim.api.nvim_get_current_buf()
					if not client then
						return
					end
					if client:supports_method("textDocument/inlayHint") then
						if vim.api.nvim_buf_is_valid(buffer) and vim.bo[buffer].buftype == "" then
							vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
							print("Inlay hints enabled:", vim.lsp.inlay_hint.is_enabled({ bufnr = buffer }))
						end
					end
					return result
				end
			end)(vim.lsp.handlers["client/registerCapability"])

			vim.lsp.enable("rust-analyzer")
			vim.lsp.enable("gopls")
			vim.lsp.enable("lua-language-server")
			vim.lsp.enable("pyright")
			vim.lsp.enable("copilot-language-server")

			vim.api.nvim_create_autocmd("LspAttach", {
				desc = "LSP actions",
				callback = function(args)
					local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
					local opts = { buffer = args.buf }

					vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
					vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
					vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
					vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
					vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
					vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
					vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
					vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
					vim.keymap.set({ "n", "x" }, "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)
					vim.keymap.set("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
					vim.keymap.set(
						"n",
						"<leader>H",
						"<cmd>lua vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())<cr>",
						opts
					)
				end,
			})

			vim.diagnostic.config({
				virtual_text = {
					source = "if_many",
					spacing = 4,
					prefix = "●",
				},
				virtual_lines = false,
				severity_sort = true,
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "master",
		lazy = false,
		build = ":TSUpdate",
		ensure_installed = {
			"c",
			"lua",
			"vim",
			"vimdoc",
			"query",
			"markdown",
			"markdown_inline",
			"tsx",
			"javascript",
			"typescript",
			"go",
		},
	},
	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				"lazy.nvim",
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
	{ -- optional blink completion source for require statements and module annotations
		"saghen/blink.cmp",
		dependencies = { "giuxtaposition/blink-cmp-copilot" },
		build = "cargo build --release",
		version = "1.*",
		opts = {
			keymap = { preset = "super-tab" },
			sources = {
				-- add lazydev to your completion providers
				default = { "copilot", "lazydev", "lsp", "path", "snippets", "buffer" },
				providers = {
					copilot = {
						name = "copilot",
						module = "blink-cmp-copilot",
						score_offset = 100,
						async = true,
					},
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						-- make lazydev completions top priority (see `:h blink.cmp`)
						score_offset = 100,
					},
				},
			},
		},
	},
}
