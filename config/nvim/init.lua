local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	-- Clone lazy.nvim
	vim.fn.system({
		"git", "clone", "--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- loader caching
if vim.loader and vim.loader.enable then
	vim.loader.enable()
end

require("lazy").setup({
	-- -------------------------------------------------------------------
	-- Basic settings and colorschemes
	-- -------------------------------------------------------------------
	{ "tpope/vim-sensible" },  -- Provides sensible vim defaults
	{
		"tjdevries/colorbuddy.nvim", -- Color scheme framework for Neovim
		config = function()
			require("colorbuddy").setup()
		end,
	},
	{
		"svrana/neosolarized.nvim", -- Modern implementation of Solarized colorscheme
		dependencies = { "tjdevries/colorbuddy.nvim" },
		config = function()
			require("neosolarized").setup({
				comment_italics = true,
				background_set = true,
			})
		end,
	},

	{
		"folke/which-key.nvim", -- Displays popup with possible key bindings
		config = function()
			require("which-key").setup()
		end,
	},

	-- -------------------------------------------------------------------
	-- Language-specific
	-- -------------------------------------------------------------------
	{
		"martinda/Jenkinsfile-vim-syntax", -- Syntax highlighting for Jenkinsfiles
		ft = { "Jenkinsfile" },
	},
	{
		"saltstack/salt-vim", -- Salt state file syntax highlighting
		ft = { "sls", "salt" },
	},
	{
		"fatih/vim-go", -- Go language support
		ft = "go",
		config = function()
			vim.g.go_fmt_command = "goimports" -- Use goimports for formatting
			vim.g.go_list_type = "quickfix" -- Use quickfix window for errors
			vim.g.go_list_height = 10 -- Set quickfix window height
		end,
	},
	{
		"tmux-plugins/vim-tmux", -- Syntax highlighting for tmux configuration files
		ft = { "tmux" },
	},
	{
		"mtdl9/vim-log-highlighting", -- Better highlighting for log files
		ft = { "log", "text" },
	},
	{
		"glench/vim-jinja2-syntax", -- Jinja2 template syntax highlighting
		ft = { "jinja", "jinja2", "htmldjango" },
	},
	{
		"chrisbra/csv.vim", -- CSV file manipulation and highlighting
		ft = "csv",
	},
	{
		'MeanderingProgrammer/render-markdown.nvim', -- Enhanced markdown rendering
		dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
		opts = {},
		ft = { "markdown", "codecompanion" }
	},

	-- -------------------------------------------------------------------
	-- Diff & Utility
	-- -------------------------------------------------------------------
	{ "AndrewRadev/linediff.vim" }, -- Compare and edit text line-by-line

	{
		"sindrets/diffview.nvim", -- Git diff viewer with enhanced features
		cmd = { "DiffviewOpen", "DiffviewFileHistory" },
	},
	{ "mikeage/occur.vim" },       -- Show all lines matching a pattern in a buffer
	{ "nvim-lua/popup.nvim" },     -- Popup API implementation from vim to neovim
	{
		"nvim-telescope/telescope.nvim", -- Fuzzy finder over lists
		dependencies = { "nvim-lua/popup.nvim", "nvim-lua/plenary.nvim" },
		opts = {
			defaults = {
				file_ignore_patterns = { ".git", "node_modules", "vendor" },
				layout_config = {
					prompt_position = "top",
				},
			},
		},
	},
	{
		"mbbill/undotree", -- Visual navigation of undo history
		config = function()
			vim.g.undotree_WindowLayout = 2
			vim.g.undotree_ShortIndicators = 1
			vim.g.undotree_SetFocusWhenToggle = 1
		end,
		keys = {
			{ "<F6>", vim.cmd.UndotreeToggle, desc = "Toggle undo tree" },
		},
	},

	-- -------------------------------------------------------------------
	-- Status bar (lualine)
	-- -------------------------------------------------------------------
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			options = {
				theme = "molokai",
				disabled_filetypes = { statusline = { "dashboard", "alpha" } },
			},
			sections = {
				lualine_b = { "branch", "diff", },
				lualine_c = {
					{
						"filename",
						file_status = true,
						path = 1, -- relative path
						symbols = {
							readonly = "[RO]",
						},
					},
				},
				lualine_x = {
					{ "encoding" },
					{ "fileformat" },
					{ "filetype" },
					{
						"diagnostics",
						sources = { 'nvim_diagnostic' },
					},
				},
			},
			tabline = {
				lualine_a = {
					{
						"buffers",
						show_filename_only = false,
						mode = 2,
					}
				},
				lualine_b = {},
				lualine_c = {},
				lualine_x = {},
				lualine_y = {},
				lualine_z = {
					{
						"tabs",
						mode = 0,
					},
				},
			},
			extensions = { "nvim-tree", "quickfix", "fugitive", "trouble", "lazy", "mason" },
		},
	},

	-- -------------------------------------------------------------------
	-- Git
	-- -------------------------------------------------------------------
	{
		"tpope/vim-fugitive", -- Git commands and integration within Vim
	},
	{
		"lewis6991/gitsigns.nvim", -- Git decorations (added/modified/removed lines)
		opts = {
			signs = {
				add          = { text = "+" },
				change       = { text = "~" },
				delete       = { text = "_" },
				topdelete    = { text = "‾" },
				changedelete = { text = "~" },
			},
		},
	},
	{
		"f-person/git-blame.nvim", -- Inline git blame information
		event = "VeryLazy",
		opts = {
			enabled = true,
			message_template = " <summary> • <date> • <author> • <sha>",
			date_format = "%r",
			virtual_text_column = 80,
		}
	},

	-- -------------------------------------------------------------------
	-- Misc
	-- -------------------------------------------------------------------
	{
		"lukas-reineke/indent-blankline.nvim", -- Visual indentation guides
		main = "ibl",
		opts = {},
	},
	{ "kshenoy/vim-signature" },                  -- Display and navigate marks
	{ "preservim/nerdcommenter" },                -- Easy commenting of code blocks
	{
		"nvim-tree/nvim-tree.lua",                -- File explorer sidebar
		dependencies = { "nvim-tree/nvim-web-devicons" },
		cmd = { "NvimTreeToggle", "NvimTreeFindFile" }, -- Only load on these commands
		keys = {
			{ "<F4>", "<cmd>NvimTreeToggle<CR>", desc = "Toggle file browser" },
		},
		opts = {
			renderer = {
				group_empty = true,
			},
		},
		config = function(_, opts)
			require("nvim-tree").setup(opts)
			-- Auto-open NvimTree on VimEnter if no file arguments
			vim.api.nvim_create_autocmd("VimEnter", {
				callback = function()
					if vim.fn.argc() == 0 then
						require("nvim-tree.api").tree.toggle()
					end
				end
			})
		end,
	},
	{ "editorconfig/editorconfig-vim" }, -- Support for .editorconfig files
	{ "tpope/vim-eunuch" },           -- Unix shell commands inside Vim
	{ "mikeage/vim-yankmarks" },      -- Enhanced mark management
	{
		"gbprod/yanky.nvim",
		dependencies = {
			{ "nvim-telescope/telescope.nvim" }
		},
		opts = {
			ring = {
				history_length = 100,
				storage = "shada",
				sync_with_numbered_registers = true,
			},
			highlight = {
				on_put = true,
				on_yank = true,
				timer = 300,
			},
			preserve_cursor_position = {
				enabled = true,
			},
			system_clipboard = {
				sync_with_ring = true,
			},
		},
		config = function(_, opts)
			-- Setup base configuration
			require("yanky").setup(opts)

			-- Configure telescope mappings inside the config function
			local mapping = require("yanky.telescope.mapping")
			require("telescope").load_extension("yank_history")

			-- Configure telescope picker
			require("yanky").setup({
				picker = {
					telescope = {
						use_default_mappings = false,
						mappings = {
							default = mapping.put("p"),
							i = {
								["<c-p>"] = mapping.put("p"),
								["<c-k>"] = mapping.put("P"),
								["<c-d>"] = mapping.delete(),
								["<c-r>"] = mapping.set_register(),
							},
							n = {
								p = mapping.put("p"),
								P = mapping.put("P"),
								d = mapping.delete(),
								r = mapping.set_register(),
							}
						}
					}
				}
			})

			-- Default yanky keymaps
			vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
			vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
			vim.keymap.set({ "n", "x" }, "<C-p>", "<Plug>(YankyCycleForward)")
			vim.keymap.set({ "n", "x" }, "<C-n>", "<Plug>(YankyCycleBackward)")

			-- Replace your neoclip mapping with yanky's telescope
			vim.keymap.set("n", "<leader>y", "<cmd>Telescope yank_history<cr>", { desc = "Yanky History" })
		end
	},

	-- -------------------------------------------------------------------
	-- FZF
	-- -------------------------------------------------------------------
	{
		"junegunn/fzf", -- Command-line fuzzy finder
		build = ":call fzf#install()",
	},
	{
		"junegunn/fzf.vim", -- Vim commands using fzf
		keys = {
			{ "<leader>t", ":Files<CR>",   desc = "Fuzzy find files" },
			{ "<leader>r", ":Tags<CR>",    desc = "Fuzzy find tags" },
			{ ";",         ":Buffers<CR>", desc = "Fuzzy find buffers" },
		},
	},

	-- -------------------------------------------------------------------
	-- LSP, Format
	-- -------------------------------------------------------------------
	{
		"b0o/SchemaStore.nvim", -- JSON schema store for LSP servers
		version = false,
		lazy = true,
	},
	{
		"williamboman/mason.nvim", -- Package manager for LSP servers, linters, formatters
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim", -- Bridge between mason.nvim and lspconfig
		dependencies = { "mason.nvim", "neovim/nvim-lspconfig" },
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			require("mason-lspconfig").setup {
				ensure_installed = { "bashls", "eslint", "lua_ls", "pylsp", "ts_ls", "yamlls", "tailwindcss", "jsonls" },
			}

			-- Set up handlers for all installed servers
			require("mason-lspconfig").setup_handlers {
				function(server_name)
					require("lspconfig")[server_name].setup {
						capabilities = capabilities,
					}
				end,
				["lua_ls"] = function()
					require("lspconfig").lua_ls.setup {
						capabilities = capabilities,
						settings = {
							Lua = {
								runtime = {
									version = "LuaJIT",
									path = vim.split(package.path, ";"),
								},
								diagnostics = {
									globals = { "vim" },
								},
								workspace = {
									library = {
										vim.env.VIMRUNTIME,
										"${3rd}/luv/library"
									},
								},
							},
						},
					}
				end,
				["pylsp"] = function()
					require("lspconfig").pylsp.setup {
						capabilities = capabilities,
						settings = {
							pylsp = {
								plugins = {
									pylint = { enabled = true },
									pycodestyle = { enabled = false },
									mccabe = { enabled = false },
									pyflakes = { enabled = false },
									flake8 = { enabled = false },
								},
							},
						},
					}
				end,
				["jsonls"] = function()
					require("lspconfig").jsonls.setup({
						settings = {
							json = {
								schemas = require("schemastore").json.schemas(),
							},
						},
					})
				end,
			}
		end,
	},
	{
		"nvimtools/none-ls.nvim",
		config = function()
			local null_ls = require("null-ls")
			null_ls.setup({
				sources = {
					null_ls.builtins.diagnostics.yamllint,
				},
			})
		end,
	},
	{
		"jay-babu/mason-null-ls.nvim",
		dependencies = { "mason.nvim", "nvimtools/none-ls.nvim" },
		config = function()
			require("mason-null-ls").setup({
				ensure_installed = { "yamllint" },
				automatic_installation = true,
			})
		end,
	},
	{
		"https://git.sr.ht/~whynothugo/lsp_lines.nvim", -- Show diagnostics using virtual lines
		config = function()
			require("lsp_lines").setup()

			-- Diagnostic config
			vim.diagnostic.config {
				float = { border = "rounded" },
				virtual_text = false,
				virtual_lines = false,
			}
		end,
		keys = {
			{ "<Leader>l", function() require("lsp_lines").toggle() end, desc = "Toggle lsp_lines" },
		},
	},
	{
		"folke/trouble.nvim", -- Pretty diagnostic list viewer
		opts = {},      -- for default options, refer to the configuration section for custom setup.
		cmd = "Trouble",
		keys = {
			{
				"<leader>xx",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Diagnostics (Trouble)",
			},
			{
				"<leader>xX",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "Buffer Diagnostics (Trouble)",
			},
			{
				"<leader>cs",
				"<cmd>Trouble symbols toggle focus=false<cr>",
				desc = "Symbols (Trouble)",
			},
			{
				"<leader>cl",
				"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
				desc = "LSP Definitions / references / ... (Trouble)",
			},
			{
				"<leader>xL",
				"<cmd>Trouble loclist toggle<cr>",
				desc = "Location List (Trouble)",
			},
			{
				"<leader>xQ",
				"<cmd>Trouble qflist toggle<cr>",
				desc = "Quickfix List (Trouble)",
			},
		},
	},
	{
		"stevearc/conform.nvim", -- Formatter integration for Neovim
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					python     = { "isort", "black" },
					javascript = { "prettierd", "prettier" },
					yaml       = { "yamlfmt", "yamlfix" },
				},
			})

			vim.api.nvim_create_user_command("Format", function(args)
				local range = nil
				if args.count ~= -1 then
					local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
					range = {
						start = { args.line1, 0 },
						["end"] = { args.line2, end_line:len() },
					}
				end
				require("conform").format({
					async = true,
					lsp_fallback = true,
					range = range,
					stop_after_first = vim.bo.filetype == "javascript" or vim.bo.filetype == "yaml",
				})
			end, { range = true })
		end,
	},

	-- -------------------------------------------------------------------
	-- AI
	-- -------------------------------------------------------------------
	{
		'zbirenbaum/copilot.lua', -- GitHub Copilot integration
		cmd = 'Copilot',
		event = 'InsertEnter',
		opts = {
			panel = {
				enabled = false,
			},
			suggestion = {
				enabled = true,
				auto_trigger = true,
				keymap = {
					dismiss = "<C-]>",
					next = "<C-j>",
					prev = "<C-k>",
				},
			},
		},
	},
	{
		"olimorris/codecompanion.nvim", -- AI coding assistant
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"j-hui/fidget.nvim",
		},
		opts = {
			adapters = {
				copilot = function()
					return require("codecompanion.adapters").extend("copilot", {
						name = "copilot",
						schema = {
							model = {
								default = "claude-3.7-sonnet",
							},
						}
					})
				end,
			},
			strategies = {
				chat = {
					adapter = "copilot",
					keymaps = { close = { modes = { n = "<NOP>", i = "<NOP>" } }, },
				},
				inline = {
					adapter = "copilot",
				},
				command = {
					adapter = "copilot",
				},
			},
			opts = {
				log_level = "DEBUG",
			},
			display = {
				action_palette = {
					provider = "telescope"
				}
			}
		},
		keys = {
			{ "<C-a>",          "<cmd>CodeCompanionActions<cr>",     mode = { "n", "v" }, desc = "CodeCompanion Actions" },
			{ "<LocalLeader>a", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "Toggle CodeCompanion Chat" },
			{ "ga",             "<cmd>CodeCompanionChat Add<cr>",    mode = "v",          desc = "Add selection to CodeCompanion Chat" },
		},
		init = function()
			-- Expand 'cc' into 'CodeCompanion' in the command line
			vim.cmd([[cab cc CodeCompanion]])

			local progress = require("fidget.progress")

			local M = {}

			function M:init()
				local group = vim.api.nvim_create_augroup("CodeCompanionFidgetHooks", {})

				vim.api.nvim_create_autocmd({ "User" }, {
					pattern = "CodeCompanionRequestStarted",
					group = group,
					callback = function(request)
						local handle = M:create_progress_handle(request)
						M:store_progress_handle(request.data.id, handle)
					end,
				})

				vim.api.nvim_create_autocmd({ "User" }, {
					pattern = "CodeCompanionRequestFinished",
					group = group,
					callback = function(request)
						local handle = M:pop_progress_handle(request.data.id)
						if handle then
							M:report_exit_status(handle, request)
							handle:finish()
						end
					end,
				})
			end

			M.handles = {}

			function M:store_progress_handle(id, handle)
				M.handles[id] = handle
			end

			function M:pop_progress_handle(id)
				local handle = M.handles[id]
				M.handles[id] = nil
				return handle
			end

			function M:create_progress_handle(request)
				return progress.handle.create({
					title = " Requesting assistance (" .. request.data.strategy .. ")",
					message = "In progress...",
					lsp_client = {
						name = M:llm_role_title(request.data.adapter),
					},
				})
			end

			function M:llm_role_title(adapter)
				local parts = {}
				table.insert(parts, adapter.formatted_name)
				if adapter.model and adapter.model ~= "" then
					table.insert(parts, "(" .. adapter.model .. ")")
				end
				return table.concat(parts, " ")
			end

			function M:report_exit_status(handle, request)
				if request.data.status == "success" then
					handle.message = "Completed"
				elseif request.data.status == "error" then
					handle.message = " Error"
				else
					handle.message = "󰜺 Cancelled"
				end
			end

			M:init()
		end,
	},
	{
		"j-hui/fidget.nvim", -- Standalone UI for LSP progress messages
		event = "LspAttach",
		opts = {
			-- Use the new v2.0 config format
			notification = {
				window = {
					winblend = 0,
					border = "rounded",
					relative = "editor",
					align = "bottom",
				},
			},
			-- For progress display
			progress = {
				display = {
					done_icon = "✓",
					progress_style = { fg = "#76946A" },
				},
				ignore = {},
			},
			-- Remove any animation or pattern configs that are causing issues
		},
	},
	-- -------------------------------------------------------------------
	-- Treesitter
	-- -------------------------------------------------------------------
	{
		"nvim-treesitter/nvim-treesitter", -- Syntax highlighting and code parsing
		build = ":TSUpdate",
		opts = {
			ensure_installed = {
				"c", "lua", "vim", "vimdoc", "query", "yaml",
				"python", "javascript", "typescript", "tsx", "html", "css", "json"
			},
			auto_install = true,
			highlight = { enable = true, disable = { "git_rebase" } },
			indent = { enable = true },
			incremental_selection = { enable = true },
		},
	},
	{
		"HiPhish/rainbow-delimiters.nvim", -- Rainbow parentheses for nested structures
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	},
	{
		"nvim-treesitter/nvim-treesitter-context", -- Shows code context at the top of buffer
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("treesitter-context").setup()
			-- Extra highlight
			vim.api.nvim_set_hl(0, "TreesitterContextBottom", { underline = true, sp = "Grey" })
		end,
	},
	{
		"windwp/nvim-ts-autotag", -- Auto-close and auto-rename HTML/XML tags
		event = "InsertEnter",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("nvim-ts-autotag").setup()
		end,
	},


	-- -------------------------------------------------------------------
	-- Completion
	-- -------------------------------------------------------------------
	{
		"hrsh7th/nvim-cmp", -- Autocompletion plugin
		dependencies = {
			"hrsh7th/cmp-nvim-lsp", -- LSP source for nvim-cmp
			"hrsh7th/cmp-buffer", -- Buffer words source
			"hrsh7th/cmp-path", -- Path source
			"hrsh7th/cmp-cmdline", -- Cmdline source
			"hrsh7th/cmp-vsnip", -- Snippets source
			"hrsh7th/vim-vsnip", -- Snippets engine
		},
		config = function()
			local cmp = require("cmp")
			cmp.setup({
				snippet = {
					expand = function(args)
						vim.fn["vsnip#anonymous"](args.body)
					end,
				},
				window = {
					completion    = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				experimental = { ghost_text = false },
				mapping = cmp.mapping.preset.insert({
					["<C-b>"]     = cmp.mapping.scroll_docs(-4),
					["<C-f>"]     = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"]     = cmp.mapping.abort(),
					["<CR>"]      = cmp.mapping.confirm({ select = true }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "vsnip" },
				}, {
					{ name = "buffer" },
				}),
			})

			-- Example: special config for gitcommit
			cmp.setup.filetype("gitcommit", {
				sources = cmp.config.sources({
					-- { name = "git" } -- if using plugin for git completions
				}, {
					{ name = "buffer" },
				})
			})
		end,
	},
})

-- Disable Copilot and Completions in CodeCompanion buffers
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "codecompanion", "markdown.codecompanion", "CodeCompanion" },
	callback = function()
		-- Disable nvim-cmp
		require("cmp").setup.buffer({ enabled = false })

		-- Disable Copilot
		vim.b.copilot_enabled = false
	end,
})

-----------------------------------------------------------------------
-- 3) GLOBAL (NON–PLUGIN-SPECIFIC) CONFIG
-----------------------------------------------------------------------
vim.opt.termguicolors = true
vim.opt.foldmethod    = "expr"
vim.opt.foldexpr      = "nvim_treesitter#foldexpr()"
vim.opt.foldcolumn    = "8"
vim.opt.foldlevel     = 99
vim.opt.number        = true
vim.opt.ignorecase    = true
vim.opt.smartcase     = true
vim.opt.incsearch     = true
vim.opt.autowriteall  = true
vim.opt.scrolloff     = 10
vim.opt.signcolumn    = "auto:1-5"
vim.opt.updatetime    = 100

-- Tab/Indent
vim.opt.tabstop       = 4
vim.opt.shiftwidth    = 4
vim.opt.expandtab     = false

-- Use 2 space indents for JavaScript & TypeScript
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "javascript", "typescript", "typescriptreact" },
	callback = function()
		vim.opt_local.shiftwidth = 2
		vim.opt_local.tabstop = 2
		vim.opt_local.expandtab = true
	end,
})

vim.opt.wildmode = "longest,list"
vim.g.c_space_errors = 1       -- Highlight trailing whitespace in C files
vim.g.csv_nomap_space = 1      -- Don't map space in CSV mode
vim.g.csv_nomap_cr = 1         -- Don't map CR in CSV mode
vim.g.csv_highlight_column = 1 -- Highlight the column under cursor in CSV files

-----------------------------------------------------------------------
-- 4) KEYMAPPINGS
-----------------------------------------------------------------------

-- Improved Tab key handling function for both indentation and Copilot
vim.keymap.set('i', '<Tab>', function()
	-- If Copilot has a suggestion and it's visible
	if require('copilot.suggestion').is_visible() then
		return require('copilot.suggestion').accept()
	end

	-- Check if we're at the beginning of a line or after whitespace only
	local col = vim.fn.col('.') - 1
	local line = vim.fn.getline('.')
	local at_indent_position = col == 0 or line:sub(1, col):match("^%s*$")

	if at_indent_position then
		-- Use tab for indentation
		return vim.api.nvim_replace_termcodes('<Tab>', true, false, true)
	else
		-- Try completion first
		local has_completion = vim.fn.pumvisible() == 1
		if has_completion then
			return vim.api.nvim_replace_termcodes('<C-n>', true, false, true)
		else
			-- Regular Tab
			return vim.api.nvim_replace_termcodes('<Tab>', true, false, true)
		end
	end
end, { expr = true, silent = true })

vim.keymap.set('i', '<S-Tab>', function()
	return vim.api.nvim_replace_termcodes('<C-d>', true, false, true)
end, { expr = true, silent = true })

-- Quick toggles & general keymaps (not tied to specific plugins)
vim.keymap.set("", "<leader>w", ":set nowrap!<CR>", { desc = "Toggle wordwrap" })
vim.keymap.set("", "<leader><Tab>", ":confirm bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("", "<leader><leader><Tab>", ":confirm bprevious<CR>", { desc = "Previous buffer" })

-- Mark config
vim.g.showmarks_include = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

-- Per-project local .vimrc
vim.g.local_vimrc = ".vimrc.local"

-- Persistent undo
vim.opt.undofile = true

-- Other ignoring
vim.opt.wildignore:append("*~,*.pyc")

-- Quickfix toggle functionality
_G.qfix_win = nil

function _G.QFixToggle(forced)
	if _G.qfix_win and forced ~= 1 then
		vim.cmd("cclose")
		_G.qfix_win = nil
	else
		vim.cmd("botright copen 10")
		_G.qfix_win = vim.fn.bufnr("$")
	end
end

-- Create a user command for QFixToggle
vim.api.nvim_create_user_command("QFix", function(opts)
	_G.QFixToggle(opts.bang and 1 or 0)
end, { bang = true })

-- Quickfix navigation keymaps
vim.keymap.set("", "<leader><PageDown>", ":cnext<CR>", { desc = "Next quickfix" })
vim.keymap.set("", "<leader><PageUp>", ":cprevious<CR>", { desc = "Previous quickfix" })
vim.keymap.set("n", "<leader>q", function() _G.QFixToggle(0) end, { silent = true, desc = "Toggle quickfix" })

-- Folding maps
vim.keymap.set("", "<leader>z", ':set foldexpr=getline(v:lnum)!~@/ foldlevel=0 foldmethod=expr<CR>',
	{ silent = true, desc = "Fold on current search" })
vim.keymap.set("n", "<space>", ':exe "silent! normal! za".(foldlevel(".")?"":"l")<CR>',
	{ silent = true, desc = "Toggle fold" })
vim.opt.foldopen:remove("search")

-- Write file as root
vim.keymap.set("c", "w!!", ":w ! sudo tee % > /dev/null", { desc = "Write file as root" })

-- Neovide special keymaps
if vim.g.neovide then
	vim.keymap.set("n", "<D-s>", ":w<CR>")   -- Save
	vim.keymap.set("v", "<D-c>", '"+y')      -- Copy
	vim.keymap.set("n", "<D-v>", '"+P')      -- Paste normal mode
	vim.keymap.set("v", "<D-v>", '"+P')      -- Paste visual mode
	vim.keymap.set("c", "<D-v>", "<C-R>+")   -- Paste command mode
	vim.keymap.set('i', '<D-v>', '<ESC>l"+Pli') -- Paste insert mode
end

-- Terraform
vim.g.terraform_fmt_on_save = 1
