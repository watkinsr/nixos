{ pkgs, ... }: rec {
  xdg = {
    configFile = {
      "pictures".source = ./home/pictures;
      "wofi/style.css".source = ./home/wofi/style.css;
      "wlogout/layout".source = ./home/wlogout/layout;
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
  };

  home.file = { ".doom.d".source = ./home/doom.d; };

  programs = {
    ssh = { enable = true; };
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
    mcfly = {
      enable = true;
      enableFishIntegration = true;
      enableFuzzySearch = true;
      keyScheme = "vim";
    };
    starship = {
      enable = true;
      enableFishIntegration = true;
    };
  };
}
