{ pkgs, ... }: {
  home-manager.users.pimeys = {
    xdg.configFile = { "nvim/lua".source = ./lua; };

    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      extraConfig = ''
        let mapleader = " "
        set nowrap
        set termguicolors

        " Emacs way of changing pwd to the current file
        " autocmd BufEnter * silent! lcd %:p:h

        " Always use system clipboard
        set clipboard+=unnamedplus

        " Keybindings
        nmap <silent> gr :References<cr>
        nmap <silent> tt :NvimTreeToggle<CR>
        nmap <silent> tr :NvimTreeRefresh<CR>
        nmap <silent> tn :NvimTreeFindFile<CR> 

        nmap <silent> <leader>n :e ~/.config/nixpkgs/<cr>
        nmap <silent> <leader>ca :CodeActions<cr>
        nmap <silent> <leader>/ :Telescope live_grep<cr>
        nmap <silent> <leader><space> :Telescope find_files<cr>
      '';
      extraPackages = with pkgs; [ tree-sitter fzf ];
      plugins = with pkgs.vimPlugins; [
        fugitive
        vim-prisma
        tabular

        vim-nix
        vim-gitgutter
        vim-markdown
        vim-surround
        vim-vsnip

        cmp-nvim-lsp
        cmp-vsnip
        cmp-path
        cmp-buffer

        fzf-lsp-nvim
        popup-nvim
        plenary-nvim
        rust-tools-nvim

        nvim-web-devicons
        {
          plugin = nvim-tree-lua;
          config = ''
            lua require'nvim-tree'.setup {}
          '';
        }

        {
          plugin = lspsaga-nvim;
          config = ''
            nnoremap <silent> rn    <cmd>Lspsaga rename<CR>
            nnoremap <silent> pd    <cmd>Lspsaga preview_definition<CR>
          '';
        }
        {
          plugin = telescope-nvim;
          config = ''
            nnoremap <silent> <c-]> <cmd>Telescope lsp_definitions<CR>
            nnoremap <silent> gD    <cmd>Telescope lsp_implementations<CR>
            nnoremap <silent> gr    <cmd>Telescope lsp_references<CR>
            nnoremap <silent> gd    <cmd>Telescope lsp_definitions<CR>
            nnoremap <silent> ga    <cmd>Telescope lsp_code_actions<CR>
            nnoremap <silent> ls    <cmd>Telescope lsp_document_symbols<CR>
            nnoremap <silent> le    <cmd>Telescope lsp_document_diagnostics<CR>
            nnoremap <silent> lw    <cmd>Telescope lsp_workspace_diagnostics<CR>
            nnoremap <silent> gc    <cmd>Telescope git_commits<CR>
            nnoremap <silent> gb    <cmd>Telescope git_branches<CR>
            nnoremap <silent> gs    <cmd>Telescope git_status<CR>
            nnoremap <silent> ch    <cmd>Telescope command_history<CR>
            nnoremap <silent> cb    <cmd>Telescope command_builtin<CR>
          '';
        }
        {
          plugin = nvim-cmp;
          config = "lua require('nvim-cmp')";
        }
        {
          plugin = (nvim-treesitter.withPlugins
            (plugins: pkgs.tree-sitter.allGrammars));
          config = ''
            lua <<EOF
              require('nvim-treesitter.configs').setup {
                highlight = {
                  enable = true,              -- false will disable the whole extension
                  -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
                  -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
                  -- Using this option may slow down your editor, and you may see some duplicate highlights.
                  -- Instead of true it can also be a list of languages
                  additional_vim_regex_highlighting = false,
                },
              }
            EOF
          '';
        }
        {
          plugin = vim-gitgutter;
          config = "let g:gitgutter_enabled = 1";
        }
        {
          plugin = vim-autoformat;
          config = ''
            autocmd BufWrite * :Autoformat
            autocmd Filetype rust setlocal omnifunc=v:lua.vim.lsp.omnifunc
            let g:autoformat_autoindent = 0
            let g:autoformat_retab = 0
            let g:autoformat_remove_trailing_spaces = 0
          '';
        }
        {
          plugin = supertab;
          config = ''
            let g:SuperTabDefaultCompletionType = "<c-n>"
          '';
        }
        {
          plugin = fzf-vim;
          config = ''
            let g:fzf_preview_window = ['right:50%', 'ctrl-/']
            let g:fzf_buffers_jump = 1

            command! -bang -nargs=* Rg
              \ call fzf#vim#grep(
              \   'rg --column --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1,
              \   fzf#vim#with_preview(), <bang>0)
          '';
        }
        {
          plugin = deoplete-nvim;
          config = ''
            let g:deoplete#enable_at_startup = 1
            call deoplete#custom#source('_', 'max_menu_width', 80)
          '';
        }
        {
          plugin = nvim-lspconfig;
          config = ''
            set completeopt=menuone,noinsert,noselect
            set shortmess+=c
            set updatetime=300
            set signcolumn=yes

            autocmd BufWritePre *.rs lua vim.lsp.buf.formatting_sync(nil, 200)
            autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()

            nnoremap <silent> g[    <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
            nnoremap <silent> g]    <cmd>lua vim.lsp.diagnostic.goto_next()<CR>
            nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>

            lua require('nvim-lspconfig')
          '';
        }
        {
          plugin = vim-airline-themes;
          config = ''
            let g:airline_theme = 'solarized'
            let g:airline_solarized_bg='dark'
          '';
        }
        {
          plugin = vim-airline;
          config = ''
            let g:airline_powerline_fonts = 1
          '';
        }
        {
          plugin = NeoSolarized;
          config = ''
            syntax enable
            set background=dark
            set termguicolors
            colorscheme NeoSolarized
          '';
        }
      ];
    };
  };
}
