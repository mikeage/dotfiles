"set runtimepath^=~/.vim runtimepath+=~/.vim/after
"let &packpath = &runtimepath
"source ~/.vimrc

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
	silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
Plug 'Iron-E/nvim-highlite'             " Colorscheme(s)
Plug 'tpope/vim-sensible'               " Defaults

Plug 'ekalinin/Dockerfile.vim'          " Language specific
Plug 'martinda/Jenkinsfile-vim-syntax'  " Language specific
Plug 'saltstack/salt-vim'               " Language specific
Plug 'fatih/vim-go'                     " Language specific
Plug 'tmux-plugins/vim-tmux'            " Language specific
Plug 'mtdl9/vim-log-highlighting'       " Language specific
Plug 'glench/vim-jinja2-syntax'         " Language specific

Plug 'AndrewRadev/linediff.vim'         " Diffs within files
Plug 'mikeage/occur.vim'                " Show all matches in the quickfix menu
Plug 'vim-airline/vim-airline'          " Status bar
Plug 'vim-airline/vim-airline-themes'   " Status bar themes
Plug 'tpope/vim-fugitive'               " Git helper
Plug 'airblade/vim-gitgutter'           " Show git changes in the signs column
Plug 'nathanaelkane/vim-indent-guides'  " Highlight indentation
Plug 'prettier/vim-prettier', { 'do': 'yarn install --frozen-lockfile --production' }
Plug 'kshenoy/vim-signature'            " Show marks in the signs column
Plug 'preservim/nerdcommenter'          " Per-langauge comments
Plug 'preservim/nerdtree'               " File browser
Plug 'editorconfig/editorconfig-vim'    " Load config from an editorconfig file
Plug 'tpope/vim-eunuch'                 " Unix commands without annoying quirks
Plug 'vim-scripts/YankRing.vim'         " Keep history of yanks, not just deletes
Plug 'mikeage/vim-yankmarks'            " Yank all marks to the named register
"Plug 'weynhamz/vim-plugin-minibufexpl'  " Better view of buffers
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } " Fuzzy finder
Plug 'junegunn/fzf.vim'                 " Functionality for fzf
Plug 'williamboman/mason.nvim'          " LSP (and other) package manager
Plug 'williamboman/mason-lspconfig.nvim' " LSP configs
Plug 'neovim/nvim-lspconfig'            " LSP configs
Plug 'mfussenegger/nvim-lint'           " Linting (complements LSP)
Plug 'rshkarin/mason-nvim-lint'         " Easy connection between mason and lint
Plug 'https://git.sr.ht/~whynothugo/lsp_lines.nvim' " LSP diagnostics
Plug 'stevearc/conform.nvim'            " Formatting
Plug 'github/copilot.vim'                " AI enhanced coding
call plug#end()

" For alacritty
set termguicolors

" Folding should always be done logically
set foldmethod=syntax
" Allow up to 8 columns to indicate folds
set foldcolumn=8
" On start, fold nothing
set foldlevel=99
" Line numbering on
set number
" Case insensitive, smart case style
set ignorecase
" Searches in lower case are treated as case insensitive. Adding one capital letter makes it case sensitive
set smartcase
" do incremental searching
set incsearch

" Write before switching buffers
set autowriteall

colorscheme highlite-solarized8

highlight Comment cterm=italic gui=italic
" NVIM set mouse=a

" Tabs are shown as a 4 space indent
set tabstop=4
" Automatic indent uses 4 spaces
set shiftwidth=4
" Use tabs, not spaces for indentation
set noexpandtab

" Mimic bash- tabs expand as far as they can go, and then show a list of the options
set wildmode=longest,list

" Remove the toolbar
set guioptions-=T

" CScope options
" Display 2 entries from the file name (dir/file)
if !has('nvim')
	set cscopepathcomp=2
	" The following searches use the quickfix windows (replace, not append)
	set cscopequickfix=s-,c-,d-,i-,t-,e-
endif
" Show where spaces and tabs are mixed
let g:c_space_errors = 1

" Missed sudos
cmap w!! %!sudo tee > /dev/null %

" Lookup the current highlight
map <leader>hi :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<' . synIDattr(synID(line("."),col("."),0),"name") . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">" . " FG:" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"fg#") . " BG:" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"bg#")<CR>

" Disable wrapping
:map <leader>w :set nowrap! <CR>

" Quicklist scrolling
map <leader><PageDown> :cnext<CR>
map <leader><PageUp> :cprevious<CR>

" Grep on windows using grep instead of findstr
if has("win32")
	set grepprg=grep\ -nH
endif

" Buffer tabbing
map <leader><Tab> :confirm bnext<CR>
map <leader><leader><Tab> :confirm bprevious<CR>
" Use minibufexpl's functions instead of bnext. This way we won't select "real" buffers in special windows
"map <leader><Tab> :confirm MBEbn<CR>
"map <leader><leader><Tab> :confirm MBEbp<CR>
" Wrap around (this is the default for bnext, but not for MBEbn)
let g:miniBufExplCycleArround=1

if has("win32")
	source $VIMRUNTIME/mswin.vim
else
	" Just take a few things that we know we want...
	set backspace=indent,eol,start whichwrap+=<,>,[,]
	" Windows (not xterm) handling
	behave mswin
endif

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
nmap <silent><leader>q :QFix<CR>

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


" <leader>z folds on the current search term
map <silent><leader>z :set foldexpr=getline(v:lnum)!~@/ foldlevel=0 foldmethod=expr<CR>
" Space expands or closes a fold
nnoremap <silent><space> :exe 'silent! normal! za'.(foldlevel('.')?'':'l')<cr>
" Search shouldn't open a fold
set foldopen-=search

" BufExplorer
:imap <F3> <ESC>:BufExplorer<CR>
:map <F3> :BufExplorer<CR>

" NERDTree
:imap <F4> <ESC>:NERDTreeToggle<CR>
:map <F4> :NERDTreeToggle<CR>
" Don't use the fancy unicode arrows
let g:NERDTreeDirArrows=0
" Default size is 60 characters instead of 31
let g:NERDTreeWinSize=60
" Load NERDTree if no files were specified
" autocmd vimenter * if !argc() | NERDTree | endif

" Ignore the special marks; only show the user defined local (a-z) and global (A-Z) marks
let g:showmarks_include="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

" Undo tree browser
nnoremap <F6> :GundoToggle<CR>

" Per project local files are named .vimrc.local, not _vimrc_local
let g:local_vimrc = ".vimrc.local"

" Reverse the sort with the best match on the top (right above the prompt)
let g:CommandTMatchWindowReverse=1
" Ignore these files
set wildignore+=*~,*.pyc

" YankRing quickview
nnoremap <silent> <F2> :YRShow<cr>
inoremap <silent> <F2> <ESC>:YRShow<cr>

" fzf (alternatively to ctrl-p)
nmap <leader>t :Files<CR>
nmap <leader>r :Tags<CR>
nmap ; :Buffers<CR>

" Persistent undo
set undofile

" Only sync from master to slave. It seems the other way isn't working right now
let g:LogViewer_SyncAll = 0

" From http://vim.wikia.com/wiki/Autoloading_Cscope_Database; search parent directories for cscope DB
function! LoadCscope()
	let db = findfile("cscope.out", ".;")
	if (!empty(db))
		let path = strpart(db, 0, match(db, "/cscope.out$"))
		set nocscopeverbose " suppress 'duplicate connection' error
		exe "cs add " . db . " " . path
		set cscopeverbose
	endif
endfunction
au BufEnter /* call LoadCscope()

" TODO
" Ignore line length in python files
" let g:ale_python_pylint_options= "--disable C0301"
" let g:ale_python_flake8_options= "--max-line-length=999 --ignore=E722,F401"
" nmap <silent> <C-k> <Plug>(ale_previous_wrap)
" nmap <silent> <C-j> <Plug>(ale_next_wrap)

" Don't go crazy with the location list in vim-go
"let g:go_fmt_fail_silently = 1
" goimports includes gofmt as well as importing
let g:go_fmt_command = "goimports"
" Always use quickfix
let g:go_list_type = "quickfix"
let g:go_list_height = 10

" AirlineTheme solarized
let g:airline_solarized_bg='dark'
let g:airline_theme='solarized'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
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


let g:terraform_fmt_on_save=1

" TODO
" inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
" inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"
" inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() . "\<cr>" : "\<cr>"

" In alacritty, the ttymouse mode is not correctly detected
if $TERM == 'alacritty'
	if !has('nvim')
		set ttymouse=sgr
	endif
endif

" For gitgutter, but also update undo file faster
set updatetime=100
" Use up to 5 columns for the signs (1 for git gutter, 2 for vim-signature,
" and 2 reserved
set signcolumn=auto:1-5

" Gitgutter configuration
let g:gitgutter_highlight_linenrs = 1
let g:gitgutter_set_sign_backgrounds = 1

" Set up mason, LSP, and lint
lua << EOF
require("mason").setup()
require("mason-lspconfig").setup {
	ensure_installed = { "bashls", "pyright", "pylsp", "yamlls", },
}
require("mason-lspconfig").setup_handlers {
	-- Automatically configure all LSP servers
	function (server_name) -- default handler (optional)
		require("lspconfig")[server_name].setup {}
	end,
	--- Named blocks for servers that require a specific setup
	["pylsp"] = function ()
		require("lspconfig")["pylsp"].setup {
			settings = {
				pylsp = {
					plugins = {
						pycodestyle = {enabled = false },
						mccabe = {enabled = false},
						pyflakes = {enabled = false},
						flake8 = {enabled = false},
						}
					}
				}
			}
	end,
}

require('lint').linters_by_ft = {
	python = {'pylint'},
	yaml = {'yamllint'}
}

vim.api.nvim_create_autocmd({"BufEnter", "InsertLeave", "BufWritePost" }, {
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

vim.api.nvim_create_user_command("Lint", function(args)
	require("lint").try_lint()
end, { range = false})

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
EOF
