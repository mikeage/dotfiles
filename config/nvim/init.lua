-- Automatically install vim-plug if it's not installed
vim.cmd([[
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
	silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
]])

local Plug = vim.fn['plug#']
vim.call('plug#begin')
Plug('tjdevries/colorbuddy.nvim')                                         -- Colorscheme(s)
Plug('svrana/neosolarized.nvim')                                          -- Colorscheme(s)

Plug('tpope/vim-sensible')                                                -- Defaults
Plug('folke/which-key.nvim')                                              -- See which key bindings are available

Plug('ekalinin/Dockerfile.vim')                                           -- Language specific
Plug('martinda/Jenkinsfile-vim-syntax')                                   -- Language specific
Plug('saltstack/salt-vim')                                                -- Language specific
Plug('fatih/vim-go')                                                      -- Language specific
Plug('tmux-plugins/vim-tmux')                                             -- Language specific
Plug('mtdl9/vim-log-highlighting')                                        -- Language specific
Plug('glench/vim-jinja2-syntax')                                          -- Language specific
Plug('chrisbra/csv.vim')                                                  -- Language specific

Plug('AndrewRadev/linediff.vim')                                          -- Diffs within files
Plug('sindrets/diffview.nvim')                                            -- Show all diffs across files (also for git)
Plug('mikeage/occur.vim')                                                 -- Show all matches in the quickfix menu
Plug('vim-airline/vim-airline')                                           -- Status bar
Plug('vim-airline/vim-airline-themes')                                    -- Status bar themes
Plug('tpope/vim-fugitive')                                                -- Git helper
Plug('airblade/vim-gitgutter')                                            -- Show git changes in the signs column
Plug('nathanaelkane/vim-indent-guides')                                   -- Highlight indentation
Plug('prettier/vim-prettier', { ['do'] = 'yarn install     --frozen-lockfile --production' })
Plug('kshenoy/vim-signature')                                             -- Show marks in the signs column
Plug('preservim/nerdcommenter')                                           -- Per-langauge comments
Plug('nvim-tree/nvim-tree.lua')                                           -- File browser
Plug('nvim-tree/nvim-web-devicons')                                       -- File browser
Plug('editorconfig/editorconfig-vim')                                     -- Load config from an editorconfig file
Plug('tpope/vim-eunuch')                                                  -- Unix commands without annoying quirks
Plug('vim-scripts/YankRing.vim')                                          -- Keep history of yanks, not just deletes
Plug('mikeage/vim-yankmarks')                                             -- Yank all marks to the named register
--Plug('weynhamz/vim-plugin-minibufexpl') " Better view of buffers
Plug('junegunn/fzf', { ['do'] = function() vim.fn['fzf#install']() end }) -- Fuzzy finder
Plug('junegunn/fzf.vim')                                                  -- Functionality for fzf
Plug('williamboman/mason.nvim')                                           -- LSP (and other) package manager
Plug('williamboman/mason-lspconfig.nvim')                                 -- LSP configs
Plug('neovim/nvim-lspconfig')                                             -- LSP configs
Plug('mfussenegger/nvim-lint')                                            -- Linting (complements LSP)
Plug('rshkarin/mason-nvim-lint')                                          -- Easy connection between mason and lint
Plug('https://git.sr.ht/~whynothugo/lsp_lines.nvim')                      -- LSP diagnostics
Plug('stevearc/conform.nvim')                                             -- Formatting
Plug('github/copilot.vim')                                                -- AI enhanced coding
Plug('mbbill/undotree')                                                   -- Undo tree
Plug('nvim-treesitter/nvim-treesitter', { ['do'] = ':TSUpdate' })         -- Treesitter
Plug('nvim-treesitter/nvim-treesitter-context')                           -- Treesitter context
Plug('hrsh7th/cmp-nvim-lsp')                                              -- Completions from LSP
Plug('hrsh7th/cmp-buffer')                                                -- Completions from buffer names
Plug('hrsh7th/cmp-path')                                                  -- Completions from file paths
Plug('hrsh7th/cmp-cmdline')                                               -- Completions from command line
Plug('hrsh7th/nvim-cmp')                                                  -- nvim completions
Plug('hrsh7th/cmp-vsnip')                                                 -- Snippets for nvim-cmp
Plug('hrsh7th/vim-vsnip')                                                 -- Snippets for nvim-cmp
vim.call('plug#end')

vim.opt.termguicolors = true
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr  = 'nvim_treesitter#foldexpr()'
vim.opt.foldcolumn = '8'
vim.opt.foldlevel = 99
vim.opt.number = true -- Show line numbers
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.autowriteall = true
require('colorbuddy').setup()
require('neosolarized').setup({
	comment_italics = true,
	background_set = true,
})

vim.opt.tabstop = 4               -- Tabs are shown as 4
vim.opt.shiftwidth = 4            -- Indentation is 4
vim.opt.wildmode = 'longest,list' -- Mimic bash- tabs expand as far as they can go, and then show a list of the options

vim.g.c_space_errors = 1          -- Trailing whitespace

vim.g.csv_nomap_space = 1         -- Don't remap space in CSV files
vim.g.csv_nomap_cr = 1            -- Don't remap CR in CSV files
vim.g.csv_highlight_column = 1    -- Highlight the column under the cursor

vim.keymap.set('c', 'w!!', ':w ! sudo tee % > /dev/null', { desc = 'Write as root' })

if vim.g.neovide then
	vim.keymap.set('n', '<D-s>', ':w<CR>')   -- Save
	vim.keymap.set('v', '<D-c>', '"+y')      -- Copy
	vim.keymap.set('n', '<D-v>', '"+P')      -- Paste normal mode
	vim.keymap.set('v', '<D-v>', '"+P')      -- Paste visual mode
	vim.keymap.set('c', '<D-v>', '<C-R>+')   -- Paste command mode
	vim.keymap.set('i', '<D-v>', '<ESC>l"+Pli') -- Paste insert mode
end

-- map <leader>hi :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<' . synIDattr(synID(line("."),col("."),0),"name") . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">" . " FG:" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"fg#") . " BG:" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"bg#")<CR>

-- Disable wordwrap
vim.keymap.set('', '<leader>w', ':set nowrap!<CR>', { desc = 'Toggle wordwrap' })

-- Buffer tabbing
vim.keymap.set('', '<leader><Tab>', ':confirm bnext<CR>', { desc = 'Next buffer' })
vim.keymap.set('', '<leader><leader><Tab>', ':confirm bprevious<CR>', { desc = 'Previous buffer' })

-- Beginning and ending of lines
vim.opt.backspace = 'indent,eol,start'
vim.opt.whichwrap:append('<>[]hl')

vim.opt.selection = "exclusive"
vim.opt.selectmode = "mouse,key"
vim.opt.mousemodel = "popup"
vim.opt.keymodel = "startsel,stopsel"

vim.cmd([[
" <leader>q toggles the quickfix window
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
-- Quickfix scrolling
vim.keymap.set('', '<leader><PageDown>', ':cnext<CR>', { desc = 'Next quickfix' })
vim.keymap.set('', '<leader><PageUp>', ':cprevious<CR>', { desc = 'Previous quickfix' })
vim.keymap.set('n', '<leader>q', ':QFix<CR>', { silent = true }, { desc = 'Toggle quickfix' })

vim.cmd([[
" Convert all sorts of fancy prints to basic ASCII. Used for e-book conversions
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

vim.keymap.set('', '<leader>z', ':set foldexpr=getline(v:lnum)!~@/ foldlevel=0 foldmethod=expr<CR>',
	{ silent = true, desc = 'Fold on current search' })

-- Fold / unfold on space
vim.keymap.set('n', '<space>', ':exe "silent! normal! za".(foldlevel(".")?"":"l")<CR>',
	{ silent = true, desc = 'Toggle fold' })

-- Don't open a fold on search
vim.opt.foldopen:remove('search')

vim.keymap.set('', '<F4>', ':NvimTreeToggle<CR>', { desc = 'Toggle file browser' })
vim.keymap.set('', '<F6>', vim.cmd.UndotreeToggle, { desc = 'Toggle undo tree' })
vim.g.undotree_WindowLayout = 2
vim.g.undotree_ShortIndicators = 1
vim.g.undotree_SetFocusWhenToggle = 1

vim.g.NERDTreeWinSize = 60

vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		if vim.fn.argc() == 0 then
			require("nvim-tree.api").tree.toggle()
		end
	end
})

-- Ignore special marks; only show the user defined local (a-z) and global (A-Z) marks
vim.g.showmarks_include = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

-- Per-project local files are named .vimrc.local, not _vimrc_local
vim.g.local_vimrc = ".vimrc.local"

vim.opt.wildignore:append('*~,*.pyc')
vim.keymap.set('n', '<leader>t', ':Files<CR>', { desc = 'Fuzzy find files' })
vim.keymap.set('n', '<leader>r', ':Tags<CR>', { desc = 'Fuzzy find tags' })
vim.keymap.set('n', ';', ':Buffers<CR>', { desc = 'Fuzzy find buffers' })

-- Persistent undofile
vim.opt.undofile = true

vim.g.LogViewer_SyncAll = 0

vim.g.go_fmt_command = "goimports"
vim.g.go_list_type = "quickfix"
vim.g.go_list_height = 10

vim.g.airline_solarized_bg = 'dark'
vim.g.airline_theme = 'molokai'
vim.g["airline#extensions#tabline#enabled"] = 1
vim.g["airline#extensions#tabline#formatter"] = 'unique_tail_improved'
vim.g["airline_powerline_fonts"] = 1

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
let g:airline_section_warning = airline#section#create_right([airline#extensions#nvimlsp#get_warning(), airline#extensions#whitespace#check(), 'GetLinterStatus'])
]])

vim.g.terraform_fmt_on_save = 1

-- Update the status bar and undo file faster
vim.opt.updatetime = 100

-- Use up to 5 columns for the signs (1 for git gutter, 2 for vim-signature, and 2 reserved)
vim.opt.signcolumn = 'auto:1-5'

vim.g.gitgutter_highlight_linenrs = 1
vim.g.gitgutter_set_sign_backgrounds = 1

require("nvim-tree").setup {
	renderer = {
		group_empty = true,
	},
}

local cmp = require 'cmp'

-- The docs say this should be required, but it's not, from what I can tell
-- vim.g.copilot_no_tab_map = true
-- vim.api.nvim_set_keymap('i', '<C-/>', 'copilot#Accept("<CR>")', { expr = true, silent = true })

cmp.setup({
	snippet = {
		-- REQUIRED - you must specify a snippet engine
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
			-- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
			-- require('snippy').expand_snippet(args.body) -- For `snippy` users.
			-- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
		end,
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	experimental = {
		ghost_text = false,
	},
	mapping = cmp.mapping.preset.insert({
		['<C-b>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.abort(),
		['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
	}),
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'vsnip' }, -- For vsnip users.
		-- { name = 'luasnip' }, -- For luasnip users.
		-- { name = 'ultisnips' }, -- For ultisnips users.
		-- { name = 'snippy' }, -- For snippy users.
	}, {
		{ name = 'buffer' },
	})
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
	sources = cmp.config.sources({
		{ name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
	}, {
		{ name = 'buffer' },
	})
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
--cmp.setup.cmdline({ '/', '?' }, {
--mapping = cmp.mapping.preset.cmdline(),
--sources = {
--{ name = 'buffer' }
--}
--})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
--cmp.setup.cmdline(':', {
--mapping = cmp.mapping.preset.cmdline(),
--sources = cmp.config.sources({
--{ name = 'path' }
--}, {
--{ name = 'cmdline' }
--})
--})

-- Set up mason, LSP, and lint
require("mason").setup()
require("mason-lspconfig").setup {
	ensure_installed = { "bashls", "eslint", "lua_ls", "pylsp", "pyright", "ts_ls", "yamlls", }
}
local capabilities = require('cmp_nvim_lsp').default_capabilities()
require("mason-lspconfig").setup_handlers {
	-- Automatically configure all LSP servers
	function(server_name) -- default handler (optional)
		require("lspconfig")[server_name].setup {
			capabilities = capabilities
		}
	end,
	--- Named blocks for servers that require a specific setup
	["lua_ls"] = function()
		require("lspconfig")["lua_ls"].setup {
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
		require("lspconfig")["pylsp"].setup {
			capabilities = capabilities,
			settings = {
				pylsp = {
					plugins = {
						pycodestyle = { enabled = false },
						mccabe = { enabled = false },
						pyflakes = { enabled = false },
						flake8 = { enabled = false },
					}
				}
			}
		}
	end,
}

require('lint').linters_by_ft = {
	python = { 'pylint' },
	yaml = { 'yamllint' }
}

vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave", "BufWritePost" }, {
	callback = function()
		local lint_status, lint = pcall(require, "lint")
		if lint_status then
			lint.try_lint()
		end
	end,
})


require("mason-nvim-lint").setup {
	ensure_installed = { "pylint", "shellcheck", "yamllint" },
}

require("lsp_lines").setup()
vim.keymap.set("", "<Leader>l", require("lsp_lines").toggle, { desc = "Toggle lsp_lines" })

vim.diagnostic.config {
	float = { border = "rounded" },
	virtual_text = false, -- Disable virtual text (the inline text on the right)
	virtual_lines = false, -- Start disabled, enable with <leader>l
}

require("conform").setup({
	formatters_by_ft = {
		python = { "isort", "black" },
		javascript = { "prettierd", "prettier" },
		yaml = { "yamlfmt", "yamlfix" },
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
	require("conform").format({ async = true, lsp_fallback = true, range = range, stop_after_first = vim.bo.filetype == "javascript" or vim.bo.filetype == "yaml", })
end, { range = true })

vim.api.nvim_create_user_command("Lint", function()
	require("lint").try_lint()
end, { range = false })

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, { desc = 'Open diagnostics float' })
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic' })
vim.keymap.set('n', '<space>q', vim.diagnostic.setqflist, { desc = 'Open diagnostics in quickfix' })

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('UserLspConfig', {}),
	callback = function(ev)
		-- Enable completion triggered by <c-x><c-o>
		vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

		-- Buffer local mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local function opts(desc)
			local opts_tbl = { buffer = ev.buf }
			opts_tbl["desc"] = desc
			return opts_tbl
		end
		vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts('Go to declaration'))
		vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts('Go to definition'))
		vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts('Show hover'))
		vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts('Go to implementation'))
		vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts('Show signature help'))
		vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts('Add workspace folder'))
		vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts('Remove workspace folder'))
		vim.keymap.set('n', '<space>wl', function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, opts('List workspace folders'))
		vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts('Go to type definition'))
		vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts('Rename'))
		vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts('Code action'))
		vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts('Go to references'))
		vim.keymap.set('n', '<space>f', function()
			vim.lsp.buf.format { async = true }
		end, opts('Format'))
	end,
})

require("nvim-treesitter.configs").setup {
	ensure_installed = { "c", "lua", "vim", "vimdoc", "query" },

	highlight = {
		enable = true,
	},
}
require("treesitter-context").setup()
vim.api.nvim_set_hl(0, "TreesitterContextBottom", { underline = true, sp = "Grey" })
vim.opt.scrolloff = 10


require("which-key").setup()
-- TODO
-- " nmap <silent> <C-k> <Plug>(ale_previous_wrap)
-- " nmap <silent> <C-j> <Plug>(ale_next_wrap)
-- " inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
-- " inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
-- " inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"
-- " inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() . "\<cr>" : "\<cr>"
