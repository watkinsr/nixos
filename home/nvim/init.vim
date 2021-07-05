call plug#begin('~/.vim/plugged')

" Collection of common configurations for the Nvim LSP client
Plug 'neovim/nvim-lspconfig'

" Extensions to built-in LSP, for example, providing type inlay hints
Plug 'nvim-lua/lsp_extensions.nvim'

" Autocompletion framework for built-in LSP
Plug 'nvim-lua/completion-nvim'

" Solarized dark
Plug 'lifepillar/vim-solarized8'

" Status bar
Plug 'vim-airline/vim-airline'

" Status bar themes
Plug 'vim-airline/vim-airline-themes'

" automatic parentheses
Plug 'tpope/vim-surround'

" Tree
Plug 'scrooloose/nerdtree'

" Commenting
Plug 'scrooloose/nerdcommenter'

" Multiple cursors
Plug 'terryma/vim-multiple-cursors'

" Yank hilights
Plug 'machakann/vim-highlightedyank'

" Terminal
Plug 'kassio/neoterm'

" Git
Plug 'tpope/vim-fugitive'
Plug 'mhinz/vim-signify'

" Nix
Plug 'LnL7/vim-nix'

" Fuzzy find
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

" Prisma hilights
Plug 'pantharshit00/vim-prisma'

" Unix utilities
Plug 'tpope/vim-eunuch'

" Lua functions
Plug 'nvim-lua/plenary.nvim'

" LSP extras
Plug 'neovim/nvim-lspconfig'

" Typescript
Plug 'jose-elias-alvarez/nvim-lsp-ts-utils'

" TOML
Plug 'cespare/vim-toml'

call plug#end()

syntax enable
filetype plugin indent on

set number
set termguicolors
set background=dark
colorscheme solarized8

" Set completeopt to have a better completion experience
" :help completeopt
" menuone: popup even when there's only one match
" noinsert: Do not insert text until a selection is made
" noselect: Do not select, force user to select one from the menu
set completeopt=menuone,noinsert,noselect

" Avoid showing extra messages when using completion
set shortmess+=c

" Configure LSP
" https://github.com/neovim/nvim-lspconfig#rust_analyzer
lua <<EOF

-- nvim_lsp object
local nvim_lsp = require'lspconfig'

-- function to attach completion when setting up lsp
local on_attach = function(client)
    require'completion'.on_attach(client)
end

-- Enable rust_analyzer
nvim_lsp.rust_analyzer.setup({ on_attach=on_attach })

-- Enable diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = true,
    signs = true,
    update_in_insert = true,
  }
)
EOF

let mapleader = ","

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" use <Tab> as trigger keys
imap <Tab> <Plug>(completion_smart_tab)
imap <S-Tab> <Plug>(completion_smart_s_tab)

" Code navigation shortcuts
nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> ga    <cmd>lua vim.lsp.buf.code_action()<CR>

" Set updatetime for CursorHold
" 300ms of no cursor movement to trigger CursorHold
set updatetime=300
" Show diagnostic popup on cursor hold
autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()

" Goto previous/next diagnostic warning/error
nnoremap <silent> g[ <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap <silent> g] <cmd>lua vim.lsp.diagnostic.goto_next()<CR>

" NERDTree
map <C-r> :NERDTreeToggle<CR>

" Jump things
map <C-p> :Rg<CR>
map <C-f> :Files<CR>

" have a fixed column for the diagnostics to appear in
" this removes the jitter when warnings/errors flow in
set signcolumn=yes

" Enable type inlay hints
autocmd CursorMoved,InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost *
\ lua require'lsp_extensions'.inlay_hints{ prefix = '', highlight = "Comment", enabled = {"TypeHint", "ChainingHint", "ParameterHint"} }

" airline stuff

let g:airline_theme='solarized'
let g:airline_powerline_fonts = 1

" yank stuff

hi HighlightedyankRegion cterm=reverse gui=reverse

" signify/git
set updatetime=100
