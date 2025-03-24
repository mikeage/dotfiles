local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	-- Clone lazy.nvim
	vim.fn.system({
		"git", "clone", "--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Loader caching
if vim.loader and vim.loader.enable then
	vim.loader.enable()
end

require("lazy").setup({
	-- -------------------------------------------------------------------
	-- Sensible Defaults
	-- -------------------------------------------------------------------
	{ "tpope/vim-sensible" },

	-- -------------------------------------------------------------------
	-- Colorschemes
	-- -------------------------------------------------------------------
	{
		"tjdevries/colorbuddy.nvim",
		config = function()
			require("colorbuddy").setup()
		end,
	},
	{
		"svrana/neosolarized.nvim",
		dependencies = { "tjdevries/colorbuddy.nvim" },
		config = function()
			require("neosolarized").setup({
				comment_italics = true,
				background_set = true,
			})
		end,
	},

	-- -------------------------------------------------------------------
	-- which-key
	-- -------------------------------------------------------------------
	{
		"folke/which-key.nvim",
		config = function()
			require("which-key").setup()
		end,
	},

	-- -------------------------------------------------------------------
	-- Language-specific
	-- -------------------------------------------------------------------
	{
		"ekalinin/Dockerfile.vim",
		ft = { "dockerfile", "Dockerfile" },
	},
	{
		"martinda/Jenkinsfile-vim-syntax",
		ft = { "Jenkinsfile" }, -- or "jenkinsfile"
	},
	{
		"saltstack/salt-vim",
		ft = { "sls", "salt" },
	},
	{
		"fatih/vim-go",
		ft = "go",
		config = function()
			-- Your vim-go settings
			vim.g.go_fmt_command = "goimports"
			vim.g.go_list_type = "quickfix"
			vim.g.go_list_height = 10
		end,
	},
	{
		"tmux-plugins/vim-tmux",
		ft = { "tmux" },
	},
	{
		"mtdl9/vim-log-highlighting",
		ft = { "log", "text" },
	},
	{
		"glench/vim-jinja2-syntax",
		ft = { "jinja", "jinja2", "htmldjango" },
	},
	{
		"chrisbra/csv.vim",
		ft = "csv",
	},

	{
		'MeanderingProgrammer/render-markdown.nvim',
		--dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
		-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
		dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {},
		ft = { "markdown", "codecompanion" }
	},
	-- -------------------------------------------------------------------
	-- Diff & Utility
	-- -------------------------------------------------------------------
	{ "AndrewRadev/linediff.vim" },
	{
		"sindrets/diffview.nvim",
		cmd = { "DiffviewOpen", "DiffviewFileHistory" },
	},
	{ "mikeage/occur.vim" },
	{ "nvim-lua/popup.nvim" },
	{
		"nvim-telescope/telescope.nvim",
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
	-- -------------------------------------------------------------------
	-- Status bar (Airline)
	-- -------------------------------------------------------------------
	{
		"vim-airline/vim-airline",
		event = "VeryLazy", -- Load it a bit later
		config = function()
			-- Airline global settings
			vim.g.airline_solarized_bg = "dark"
			vim.g.airline_theme = "molokai"
			vim.g["airline#extensions#tabline#enabled"] = 1
			vim.g["airline#extensions#tabline#formatter"] = "unique_tail_improved"
			vim.g["airline_powerline_fonts"] = 1
		end,
	},
	{
		"vim-airline/vim-airline-themes",
		dependencies = { "vim-airline/vim-airline" },
	},

	-- -------------------------------------------------------------------
	-- Git
	-- -------------------------------------------------------------------
	{ "tpope/vim-fugitive" },
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup({
				signs = {
					add          = { text = "+" },
					change       = { text = "~" },
					delete       = { text = "_" },
					topdelete    = { text = "‾" },
					changedelete = { text = "~" },
				},
			})
		end,
	},

	-- -------------------------------------------------------------------
	-- Misc
	-- -------------------------------------------------------------------
	{ "nathanaelkane/vim-indent-guides" },
	{
		"prettier/vim-prettier",
		build = "yarn install --frozen-lockfile --production",
	},
	{ "kshenoy/vim-signature" },
	{ "preservim/nerdcommenter" },
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		cmd = { "NvimTreeToggle", "NvimTreeFindFile" }, -- Only load on these commands
		keys = {
			{ "<F4>", "<cmd>NvimTreeToggle<CR>", desc = "Toggle file browser" },
		},
		config = function()
			require("nvim-tree").setup({
				renderer = {
					group_empty = true,
				},
			})
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
	{ "editorconfig/editorconfig-vim" },
	{ "tpope/vim-eunuch" },
	{ "vim-scripts/YankRing.vim" },
	{ "mikeage/vim-yankmarks" },

	-- -------------------------------------------------------------------
	-- FZF
	-- -------------------------------------------------------------------
	{
		"junegunn/fzf",
		build = ":call fzf#install()",
	},
	{ "junegunn/fzf.vim" },

	-- -------------------------------------------------------------------
	-- Undo
	-- -------------------------------------------------------------------
	{
		"mbbill/undotree",
		config = function()
			vim.g.undotree_WindowLayout = 2
			vim.g.undotree_ShortIndicators = 1
			vim.g.undotree_SetFocusWhenToggle = 1
		end,
	},

	-- -------------------------------------------------------------------
	-- LSP, Lint, Format
	-- -------------------------------------------------------------------
	{
		"b0o/SchemaStore.nvim",
		version = false, -- or pin a version
		lazy = true, -- optional
	},
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
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
										[vim.fn.expand("$VIMRUNTIME/lua")] = true,
										[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
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
		"mfussenegger/nvim-lint",
		config = function()
			require("lint").linters_by_ft = {
				python = { "pylint" },
				yaml   = { "yamllint" },
			}
			vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave", "BufWritePost" }, {
				callback = function()
					local lint_status, lint = pcall(require, "lint")
					if lint_status then
						lint.try_lint()
					end
				end,
			})
		end,
	},
	{
		"rshkarin/mason-nvim-lint",
		dependencies = { "mason.nvim", "mfussenegger/nvim-lint" },
		config = function()
			require("mason-nvim-lint").setup {
				ensure_installed = { "pylint", "shellcheck", "yamllint" },
			}
		end,
	},
	{
		"https://git.sr.ht/~whynothugo/lsp_lines.nvim",
		config = function()
			require("lsp_lines").setup()

			-- Diagnostic config
			vim.diagnostic.config {
				float = { border = "rounded" },
				virtual_text = false,
				virtual_lines = false,
			}

			-- Keymap to toggle
			vim.keymap.set("", "<Leader>l", require("lsp_lines").toggle, { desc = "Toggle lsp_lines" })
		end,
	},
	{
		"stevearc/conform.nvim",
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

			vim.api.nvim_create_user_command("Lint", function()
				require("lint").try_lint()
			end, { range = false })
		end,
	},

	-- -------------------------------------------------------------------
	-- AI
	-- -------------------------------------------------------------------
	{ "github/copilot.vim" },
	{
		"olimorris/codecompanion.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
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
	},
	-- -------------------------------------------------------------------
	-- Treesitter
	-- -------------------------------------------------------------------
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup {
				ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "yaml" },
				highlight = { enable = true },
			}
		end,
	},
	{
		"HiPhish/rainbow-delimiters.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("treesitter-context").setup()
			-- Extra highlight
			vim.api.nvim_set_hl(0, "TreesitterContextBottom", { underline = true, sp = "Grey" })
		end,
	},
	{
		"windwp/nvim-ts-autotag",
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
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/cmp-vsnip",
			"hrsh7th/vim-vsnip",
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
vim.g.c_space_errors = 1
vim.g.csv_nomap_space = 1
vim.g.csv_nomap_cr = 1
vim.g.csv_highlight_column = 1

-- Quick toggles & keymaps
vim.keymap.set("", "<leader>w", ":set nowrap!<CR>", { desc = "Toggle wordwrap" })
vim.keymap.set("", "<leader><Tab>", ":confirm bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("", "<leader><leader><Tab>", ":confirm bprevious<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<leader>t", ":Files<CR>", { desc = "Fuzzy find files" })
vim.keymap.set("n", "<leader>r", ":Tags<CR>", { desc = "Fuzzy find tags" })
vim.keymap.set("n", ";", ":Buffers<CR>", { desc = "Fuzzy find buffers" })

vim.keymap.set("", "<F6>", vim.cmd.UndotreeToggle, { desc = "Toggle undo tree" })

-- Code companion keymaps
vim.keymap.set({ "n", "v" }, "<C-a>", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<LocalLeader>a", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
vim.keymap.set("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })
-- Expand 'cc' into 'CodeCompanion' in the command line
vim.cmd([[cab cc CodeCompanion]])

-- Mark config
vim.g.showmarks_include = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

-- Per-project local .vimrc
vim.g.local_vimrc = ".vimrc.local"

-- Persistent undo
vim.opt.undofile = true

-- Other ignoring
vim.opt.wildignore:append("*~,*.pyc")

-- Quickfix toggle commands
vim.cmd([[
command! -bang -nargs=? QFix call QFixToggle(<bang>0)
function! QFixToggle(forced)
  if exists("g:qfix_win") && a:forced == 0
    cclose
    unlet g:qfix_win
  else
    botright copen 10
    let g:qfix_win = bufnr("$")
  endif
endfunction
]])
vim.keymap.set("", "<leader><PageDown>", ":cnext<CR>", { desc = "Next quickfix" })
vim.keymap.set("", "<leader><PageUp>", ":cprevious<CR>", { desc = "Previous quickfix" })
vim.keymap.set("n", "<leader>q", ":QFix<CR>", { silent = true, desc = "Toggle quickfix" })

-- Convert fancy characters to ASCII
vim.cmd([[
function! ToAscii()
  normal mZ
  %s///ge
  %s/\n\n\+/\r/ge
  %s/\t/ /ge
  %s/  \+/ /ge
  %s/[]/"/ge
  %s/[]/'/ge
  %s/ç/c/ge
  %s/[éë]/e/ge
  %s/ü/u/ge
  %s/[äâ]/a/ge
  %s/[óö]/o/ge
  %s/©/(c)/ge
  %s//-/ge
  normal `Z
endfunction
]])

-- Folding maps
vim.keymap.set("", "<leader>z", ':set foldexpr=getline(v:lnum)!~@/ foldlevel=0 foldmethod=expr<CR>',
	{ silent = true, desc = "Fold on current search" })
vim.keymap.set("n", "<space>", ':exe "silent! normal! za".(foldlevel(".")?"":"l")<CR>',
	{ silent = true, desc = "Toggle fold" })
vim.opt.foldopen:remove("search")

-- Sample mapping to write a file as root
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

-- Extra airline config (for whitespace, linter status, etc.)
vim.cmd([[
function! Get_linter_status()
  let linter = luaeval('require("lint").get_running()')
  if len(linter) == 0
    return ''
  else
    return 'L: ' .. join(linter, ', ')
  end
endfunction
call airline#parts#define_function('GetLinterStatus', 'Get_linter_status')
let g:airline_section_warning = airline#section#create_right([
  \ airline#extensions#nvimlsp#get_warning(),
  \ airline#extensions#whitespace#check(),
  \ 'GetLinterStatus'
\ ])
]])

-- Terraform
vim.g.terraform_fmt_on_save = 1
