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
Plug('Iron-E/nvim-highlite')                                              -- Colorscheme(s)
Plug('tpope/vim-sensible')                                                -- Defaults

Plug('ekalinin/Dockerfile.vim')                                           -- Language specific
Plug('martinda/Jenkinsfile-vim-syntax')                                   -- Language specific
Plug('saltstack/salt-vim')                                                -- Language specific
Plug('fatih/vim-go')                                                      -- Language specific
Plug('tmux-plugins/vim-tmux')                                             -- Language specific
Plug('mtdl9/vim-log-highlighting')                                        -- Language specific
Plug('glench/vim-jinja2-syntax')                                          -- Language specific
Plug('chrisbra/csv.vim')                                                  -- Language specific

Plug('AndrewRadev/linediff.vim')                                          -- Diffs within files
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
vim.call('plug#end')

vim.opt.termguicolors = true
vim.opt.foldmethod = 'syntax'
vim.opt.foldcolumn = '8'
vim.opt.foldlevel = 99
vim.opt.number = true -- Show line numbers
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.autowriteall = true
vim.cmd.colorscheme('highlite-solarized8')
vim.opt.tabstop = 4               -- Tabs are shown as 4
vim.opt.shiftwidth = 4            -- Indentation is 4
vim.opt.wildmode = 'longest,list' -- Mimic bash- tabs expand as far as they can go, and then show a list of the options

vim.g.c_space_errors = 1          -- Trailing whitespace

vim.g.csv_nomap_space = 1         -- Don't remap space in CSV files
vim.g.csv_nomap_cr = 1            -- Don't remap CR in CSV files
vim.g.csv_highlight_column = 1    -- Highlight the column under the cursor

vim.keymap.set('c', 'w!!', ':w ! sudo tee % > /dev/null')

-- map <leader>hi :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<' . synIDattr(synID(line("."),col("."),0),"name") . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">" . " FG:" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"fg#") . " BG:" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"bg#")<CR>

-- Disable wordwrap
vim.keymap.set('', '<leader>w', ':set nowrap!<CR>')

-- Buffer tabbing
vim.keymap.set('', '<leader><Tab>', ':confirm bnext<CR>')
vim.keymap.set('', '<leader><leader><Tab>', ':confirm bprevious<CR>')

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
vim.keymap.set('', '<leader><PageDown>', ':cnext<CR>')
vim.keymap.set('', '<leader><PageUp>', ':cprevious<CR>')
vim.keymap.set('n', '<leader>q', ':QFix<CR>', { silent = true })

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

vim.cmd([[
map <silent><leader>z :set foldexpr=getline(v:lnum)!~@/ foldlevel=0 foldmethod=expr<CR>
]])

-- Fold / unfold on space
vim.keymap.set('n', '<space>', ':exe "silent! normal! za".(foldlevel(".")?"":"l")<CR>', { silent = true })

-- Don't open a fold on search
vim.opt.foldopen:remove('search')

vim.keymap.set('', '<F4>', ':NvimTreeToggle<CR>')
vim.keymap.set('n', '<F6>', ':GundoToggle<CR>')

vim.g.NERDTreeWinSize = 60

vim.cmd([[
autocmd vimenter * if !argc() | NvimTreeOpen | endif
]])

-- Ignore special marks; only show the user defined local (a-z) and global (A-Z) marks
vim.g.showmarks_include = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

-- Per-project local files are named .vimrc.local, not _vimrc_local
vim.g.local_vimrc = ".vimrc.local"

vim.opt.wildignore:append('*~,*.pyc')
vim.keymap.set('n', '<leader>t', ':Files<CR>')
vim.keymap.set('n', '<leader>r', ':Tags<CR>')
vim.keymap.set('n', ';', ':Buffers<CR>')

-- Persistent undofile
vim.opt.undofile = true

vim.g.LogViewer_SyncAll = 0

vim.g.go_fmt_command = "goimports"
vim.g.go_list_type = "quickfix"
vim.g.go_list_height = 10

vim.g.airline_solarized_bg = 'dark'
vim.g.airline_theme = 'solarized'
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
-- Set up mason, LSP, and lint
require("mason").setup()
require("mason-lspconfig").setup {
	ensure_installed = { "bashls", "pyright", "pylsp", "yamlls", "lua_ls" },
}
require("mason-lspconfig").setup_handlers {
	-- Automatically configure all LSP servers
	function(server_name) -- default handler (optional)
		require("lspconfig")[server_name].setup {}
	end,
	--- Named blocks for servers that require a specific setup
	["lua_ls"] = function()
		require("lspconfig")["lua_ls"].setup {
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
	ensure_installed = { "pylint" },
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
		-- Use a sub-list to run only the first available formatter
		javascript = { { "prettierd", "prettier" } },
		yaml = { { "yamlfmt", "yamlfix" } },
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
	require("conform").format({ async = true, lsp_fallback = true, range = range })
end, { range = true })

vim.api.nvim_create_user_command("Lint", function()
	require("lint").try_lint()
end, { range = false })

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setqflist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('UserLspConfig', {}),
	callback = function(ev)
		-- Enable completion triggered by <c-x><c-o>
		vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

		-- Buffer local mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local opts = { buffer = ev.buf }
		vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
		vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
		vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
		vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
		vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
		vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
		vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
		vim.keymap.set('n', '<space>wl', function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, opts)
		vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
		vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
		vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
		vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
		vim.keymap.set('n', '<space>f', function()
			vim.lsp.buf.format { async = true }
		end, opts)
	end,
})

-- TODO
-- " nmap <silent> <C-k> <Plug>(ale_previous_wrap)
-- " nmap <silent> <C-j> <Plug>(ale_next_wrap)
-- " inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
-- " inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
-- " inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"
-- " inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() . "\<cr>" : "\<cr>"
