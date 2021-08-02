{ pkgs, inputs, nixpkgs, config, lib, ... }:

rec {
  xdg.configFile = {
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
  };

  home.file = {
    ".doom.d".source = ./home/doom.d;
  };

  services = {
    emacs = {
      enable = true;
      package = pkgs.emacsPgtkGcc;
    };
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
      extraPackages = (epkgs: [ epkgs.vterm ] );
    };
    direnv = {
      enable = true;
      enableFishIntegration = true;
      nix-direnv.enable = true;
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
    mcfly = {
      enable = true;
      enableFishIntegration = true;
      enableFuzzySearch = true;
      keyScheme = "vim";
    };
    fish = {
      enable = true;
      interactiveShellInit = ''
        set PATH ~/.cargo/bin ~/.local/bin $PATH
        set EDITOR ${pkgs.neovim}/bin/nvim
      '';
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
        colors = import ./home/alacritty/solarized_dark.nix {};
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
    "*color5"  = "#b16286";
    "*color13" = "#d3869b";
    "*color6" = "#689d6a";
    "*color14" = "#8ec07c";
    "*color7" = "#a89984";
    "*color15" = "#ebdbb2";
  };
}
