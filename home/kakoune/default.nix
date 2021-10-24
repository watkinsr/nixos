{ pkgs, ... }: {
  programs.kakoune = {
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
      ui = { changeColors = false; };
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
          effect =
            ": require-module fzf; require-module fzf-file; fzf-file<ret>";
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
          option = "^.*.nix$";
          commands = ''
            set-option buffer formatcmd 'nixpkgs-fmt'
            set-option buffer indentwidth 2
          '';
        }
        {
          name = "BufWritePre";
          option = "^.*.nix$";
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
}
