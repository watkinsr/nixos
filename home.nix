{ pkgs, inputs, nixpkgs, config, lib, ... }:

rec {
  xdg = {
    configFile = {
      "pictures".source = ./home/pictures;
      "wofi/style.css".source = ./home/wofi/style.css;
      "picom/config".source = ./home/picom/config;
      "dunst/dunstrc".source = ./home/dunst/dunstrc;
      "wlogout/layout".source = ./home/wlogout/layout;
      "i3/config".source = ./home/i3/config;
      "i3/i3exit".source = ./home/i3/i3exit;
      "i3/i3subscribe".source = ./home/i3/i3subscribe;
      "i3blocks/config".source = ./home/i3blocks/config;
      "i3blocks/i3status.conf".source = ./home/i3blocks/i3status.conf;
      "scripts/battery.sh".source = ./home/scripts/battery.sh;
      "scripts/weather.sh".source = ./home/scripts/weather.sh;
      "scripts/glucose.sh".source = ./home/scripts/glucose.sh;
      "scripts/cpu.pl".source = ./home/scripts/cpu.pl;
      "scripts/memory.sh".source = ./home/scripts/memory.sh;
      "scripts/temperature.sh".source = ./home/scripts/temperature.sh;
      "scripts/wifi.sh".source = ./home/scripts/wifi.sh;
      "scripts/dist.js".source = ./home/scripts/dist.js;
      "mc/selenized.ini".source = ./home/mc/selenized.ini;
      "kak-lsp/kak-lsp.toml".source = ./home/kak-lsp/kak-lsp.toml;
    };
    desktopEntries = {
      spotify = {
        name = "Spotify";
        genericName = "Music Player";
        exec = "spotify";
        terminal = false;
        categories = [ "Application" "Music" ];
      };
      element = {
        name = "Element";
        genericName = "Chat";
        exec = "element-desktop --use-tray-icon --enable-features=UseOzonePlatform --ozone-platform=wayland";
        terminal = false;
        categories = [ "Application" "Chat" ];
      };
    };
  };

  home.file = {
    ".doom.d".source = ./home/doom.d;
  };

  services = {
    redshift = {
      enable = true;
      package = pkgs.redshift-wlr;
      latitude = "52.4";
      longitude = "13.4";
      settings = {
        redshift = {
          brightness-day = "1";
          brightness-night = "0.75";
        };
      };
      tray = true;
    };
  };

  programs = {
    go.enable = true;
    ssh = {
      enable = true;
      extraConfig = ''
        Host oneplus-8-pro
          User u0_a340
          Port 2222
      '';
    };
    emacs = {
      enable = true;
      package = pkgs.emacsPgtkGcc;
      extraPackages = (epkgs: [ epkgs.vterm ]);
    };
    direnv = {
      enable = true;
      enableFishIntegration = true;
      nix-direnv = {
        enable = true;
        enableFlakes = true;
      };
    };
    git = {
      enable = true;
      delta = {
        enable = true;
        options = {
          syntax-theme = "solarized-dark";
          minus-style = "#fdf6e3 #dc322f";
          plus-style = "#fdf6e3 #859900";
          side-by-side = false;
        };
      };
      userName = "Julius de Bruijn";
      userEmail = "julius+github@nauk.io";
      extraConfig = {
        pull.rebase = true;
        init.defaultBranch = "main";
      };
      aliases = {
        co = "checkout";
        br = "branch";
        st = "status";
        ci = "commit";
      };
    };
    kakoune = {
      enable = true;
      plugins = with pkgs.kakounePlugins; [
        pkgs.tom.kakounePlugins.kak-lsp
        fzf-kak
        powerline-kak
        kakoune-rainbow
        kakboard
      ];
      config = {
        colorScheme = "solarized-dark";
        numberLines = {
          enable = false;
          highlightCursor = false;
          relative = false;
        };
        ui = {
          changeColors = false;
        };
        keyMappings = [
          {
            key = "l";
            mode = "user";
            docstring = "LSP mode";
            effect = ": enter-user-mode lsp<ret>";
          }
          {
            key = "<space>";
            mode = "normal";
            docstring = "leader";
            effect = ",";
          }
          {
            key = "<backspace>";
            mode = "normal";
            docstring = "remove all sels except main";
            effect = "<space>";
          }
          {
            key = "w";
            mode = "user";
            docstring = "duplicate the window";
            effect = ": dup-window<ret>";
          }
          {
            key = "c";
            mode = "user";
            docstring = "go to home.nix";
            effect = ": e ~/.config/nixpkgs/home.nix<ret>";
          }
          {
            key = "f";
            mode = "user";
            docstring = "fuzzy find";
            effect = ": fzf-mode<ret>";
          }
          {
            key = "<space>";
            mode = "user";
            docstring = "find files";
            effect = ": require-module fzf; require-module fzf-file; fzf-file<ret>";
          }
          {
            key = "r";
            mode = "user";
            docstring = "browse files";
            effect = ": browse-file %sh{dirname $kak_buffile} <ret>";
          }
          {
            key = "l";
            mode = "user";
            docstring = "LSP mode";
            effect = ": enter-user-mode lsp<ret>";
          }
        ];
        hooks = [
          {
            name = "WinCreate";
            option = ".*";
            commands = ''
              set-option global termcmd 'footclient sh -c'
              kakboard-enable
            '';
          }
          {
            name = "ModuleLoaded";
            option = "fzf-file";
            commands = ''
              set-option global fzf_file_command 'rg --files --follow'
            '';
          }
          {
            name = "BufCreate";
            option = "^.*\.nix$";
            commands = ''
              set-option buffer formatcmd 'nixpkgs-fmt'
              set-option buffer indentwidth 2
            '';
          }
          {
            name = "BufWritePre";
            option = "^.*\.nix$";
            commands = ''
              eval format
            '';
          }
          {
            name = "WinSetOption";
            option = "filetype=<language>";
            commands = ''
              hook window -group semantic-tokens BufReload .* lsp-semantic-tokens
              hook window -group semantic-tokens NormalIdle .* lsp-semantic-tokens
              hook window -group semantic-tokens InsertIdle .* lsp-semantic-tokens
              hook -once -always window WinSetOption filetype=.* %{
                remove-hooks window semantic-tokens
              }
            '';
          }
          {
            name = "WinSetOption";
            option = "filetype=(rust|python|go|javascript|typescript|c|cpp)";
            commands = "lsp-enable-window";
          }
          {
            name = "WinSetOption";
            option = "filetype=rust";
            commands = ''
              hook window BufWritePre .* lsp-formatting-sync
              hook window -group rust-inlay-hints BufReload .* rust-analyzer-inlay-hints
              hook window -group rust-inlay-hints NormalIdle .* rust-analyzer-inlay-hints
              hook window -group rust-inlay-hints InsertIdle .* rust-analyzer-inlay-hints
              hook -once -always window WinSetOption filetype=.* %{
                remove-hooks window rust-inlay-hints
              }
            '';
          }
        ];
      };
      extraConfig = ''
        define-command -override \
                -docstring "Duplicate the current window in a new terminal sharing the same session" \
                dup-window \
                %{ nop %sh{ footclient -N kak -c $kak_session $kak_buffile } }

        define-command -override -docstring 'Open a file with ranger' \
        -params 0..1 \
        browse-file \
        %{ eval %sh{
                TMPFILE=`mktemp`;
                footclient ranger --choosefile=$TMPFILE $1;
                if [[ -s $TMPFILE ]]
                then
                  echo "edit \"`cat $TMPFILE`\"";
                else
                  echo nop;
                fi
        } }

        eval %sh{kak-lsp --kakoune -s $kak_session --log /tmp/kak-lsp.log}
        powerline-start
      '';

    };
    mcfly = {
      enable = true;
      enableFishIntegration = true;
      enableFuzzySearch = true;
      keyScheme = "vim";
    };
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      plugins = with pkgs.vimPlugins; [
        deoplete-rust
        deoplete-lsp

        {
          plugin = vim-autoformat;
          config = ''
            autocmd BufWrite * :Autoformat
            autocmd Filetype rust setlocal omnifunc=v:lua.vim.lsp.omnifunc
          '';
        }
        {
          plugin = supertab;
          config = ''
            let g:SuperTabDefaultCompletionType = "<c-n>"
          '';
        }
        {
          plugin = ctrlp-vim;
          config = ''
            let g:ctrlp_working_path_mode = 'ra'
            let g:ctrlp_user_command = 'rg %s --files --hidden --color=never --glob ""'
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
              lua << EOF
              local nvim_lsp = require('lspconfig')

              -- Use an on_attach function to only map the following keys
              -- after the language server attaches to the current buffer
              local on_attach = function(client, bufnr)
                local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
                local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

                -- Enable completion triggered by <c-x><c-o>
                buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

                -- Mappings.
                local opts = { noremap=true, silent=true }

                -- See `:help vim.lsp.*` for documentation on any of the below functions
                buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
                buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
                buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
                buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
                buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
                buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
                buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
                buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
                buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
                buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
                buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
                buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
                buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
                buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
                buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
                buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
                buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

              end

              -- Use a loop to conveniently call 'setup' on multiple servers and
              -- map buffer local keybindings when the language server attaches
              local servers = { 'rust_analyzer' }
              for _, lsp in ipairs(servers) do
                nvim_lsp[lsp].setup {
                  on_attach = on_attach,
                  flags = {
                    debounce_text_changes = 150,
                  }
                }
              end
            EOF
          '';
        }
        {
          plugin = vim-airline;
          config = "let g:airline_powerline_fonts = 1";
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
    fish = {
      enable = true;
      interactiveShellInit = ''
        set PATH ~/.cargo/bin ~/.local/bin $PATH
        set EDITOR nvim
      '';
      functions = {
        flakify = ''
          if not test -e flake.nix
            wget https://raw.githubusercontent.com/pimeys/nix-prisma-example/main/flake.nix
            nvim flake.nix
          end
          if not test -e .envrc
            echo "use flake" > .envrc
            direnv allow
          end
        '';
      };
      plugins = [
        {
          name = "agnoster";
          src = pkgs.fetchFromGitHub {
            owner = "oh-my-fish";
            repo = "theme-agnoster";
            rev = "43860ce1536930bca689470e26083b0a5b7bd6ae";
            sha256 = "16k94hz3s6wayass6g1lhlcjmbpf2w8mzx90qrrqp120h80xwp25";
          };
        }
      ];
      shellAliases = {
        cw = "cargo watch -s 'clear; cargo check --tests --all-features --color=always 2>&1 | head -40'";
        cwa = "cargo watch -s 'clear; cargo check --tests --features=all --color=always 2>&1 | head -40'";
        ls = "exa --git --icons";
      };
    };
    starship = {
      enable = true;
      enableFishIntegration = true;
    };
    beets = {
      enable = true;
      settings = {
        directory = "/mnt/music";
        library = "/home/pimeys/.config/beets/musiclibrary.blb";
        plugins = "convert replaygain fetchart";
        replaygain = {
          backend = "gstreamer";
        };
        import = {
          move = true;
        };
        fetchart = {
          auto = true;
        };
        convert = {
          auto = false;
          threads = 4;
          copy_album_art = true;
          embed = true;
          format = "opus";
          dest = "/mnt/opus/";
          formats = {
            opus = {
              command = "ffmpeg -i $source -ar 48000 -ac 2 -ab 96k $dest";
              extension = "opus";
            };
          };
        };
      };
    };
    alacritty = {
      enable = true;
      settings = {
        env = {
          TERM = "xterm-256color";
        };
        scrolling = {
          history = 100000;
        };
        font = {
          normal = {
            family = "Inconsolata";
            style = "Regular";
          };
          bold = {
            family = "Inconsolata";
            style = "Bold";
          };
          italic = {
            family = "Inconsolata";
            style = "Italic";
          };
          bold_italic = {
            family = "Inconsolata";
            style = "Bold Italic";
          };
          size = 14.0;
        };
        background_opacity = 0.9;
        colors = import ./home/alacritty/solarized_dark.nix { };
      };
    };
  };

  xresources.properties = {
    "Xft.dpi" = 96;
    "Xft.antialias" = true;
    "Xft.hinting" = true;
    "Xft.rgba" = "rgb";
    "Xft.autohint" = false;
    "Xft.hintstyle" = "hintfull";
    "Xft.lcdfilter" = "lcddefault";
    "rofi.modi" = "run";
    "rofi.font" = "Inconsolata for Powerline 15";
    "!rofi.width" = 100;
    "!rofi.lines" = 5;
    "!rofi.columns" = 1;
    "rofi.opacity" = 80;
    "rofi.color-normal" = "#073642, #eee8d5, #002b36, #eee8d5, #073642";
    "rofi.color-urgent" = "#073642, #eee8d5, #002b36, #eee8d5, #073642";
    "rofi.color-active" = "#073642, #eee8d5, #002b36, #eee8d5, #073642";
    "rofi.color-window" = "#073642, #eee8d5";
    "!rofi.location" = 2;
    "!rofi.padding" = 25;
    "rofi.fuzzy" = false;
    "*background" = "#1d2021";
    "*foreground" = "#ebdbb2";
    "*color0" = "#282828";
    "*color8" = "#928374";
    "*color1" = "#cc241d";
    "*color9" = "#fb4934";
    "*color2" = "#98971a";
    "*color10" = "#b8bb26";
    "*color3" = "#d79921";
    "*color11" = "#fabd2f";
    "*color4" = "#458588";
    "*color12" = "#83a598";
    "*color5" = "#b16286";
    "*color13" = "#d3869b";
    "*color6" = "#689d6a";
    "*color14" = "#8ec07c";
    "*color7" = "#a89984";
    "*color15" = "#ebdbb2";
  };
}

