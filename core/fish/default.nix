{ lib, home-manager, pkgs, ... }: {
  home-manager.users.ryan.programs.fish = {
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
    plugins = [{
      name = "agnoster";
      src = pkgs.fetchFromGitHub {
        owner = "oh-my-fish";
        repo = "theme-agnoster";
        rev = "43860ce1536930bca689470e26083b0a5b7bd6ae";
        sha256 = "16k94hz3s6wayass6g1lhlcjmbpf2w8mzx90qrrqp120h80xwp25";
      };
    }];
    shellAliases = {
      cw =
        "cargo watch -s 'clear; cargo check --tests --all-features --color=always 2>&1 | head -40'";
      cwa =
        "cargo watch -s 'clear; cargo check --tests --features=all --color=always 2>&1 | head -40'";
      ls = "exa --git --icons";
    };
  };
}
