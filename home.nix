{ pkgs, inputs, nixpkgs, config, lib, ... }:

rec {
  xdg = {
    configFile = {
      "nvim/lua".source = ./home/nvim/lua;
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
      firefox = {
        name = "Firefox";
        genericName = "Web Browser";
        exec = "firefox";
        terminal = false;
        categories = [ "Application" ];
      };
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
        exec =
          "element-desktop --use-tray-icon --enable-features=UseOzonePlatform --ozone-platform=wayland";
        terminal = false;
        categories = [ "Application" "Chat" ];
      };
    };
  };

  home.file = { ".doom.d".source = ./home/doom.d; };

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
    kakoune = import home/kakoune { pkgs = pkgs; };
    neovim = import home/nvim { pkgs = pkgs; };

    go.enable = true;
    ssh = { enable = true; };

    firefox = {
      enable = true;
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        bitwarden
        multi-account-containers
        refined-github
        sponsorblock
        ublock-origin
        decentraleyes
        clearurls
        kristofferhagen-nord-theme
        ninja-cookie
        old-reddit-redirect
        unpaywall
        zoom-redirector
      ];
      profiles = {
        default = {
          isDefault = true;
          settings = {
            # Don't allow websites to prevent use of right-click, or otherwise
            # messing with the context menu.
            "dom.event.contextmenu.enabled" = false;

            # Don't allow websites to prevent copy and paste. Disable
            # notifications of copy, paste, or cut functions. Stop webpage
            # knowing which part of the page had been selected.
            "dom.event.clipboardevents.enabled" = false;

            # Do not track from battery status.
            "dom.battery.enabled" = false;

            # Show punycode. Help protect from character 'spoofing'.
            "network.IDN_show_punycode" = true;

            # Disable site reading installed plugins.
            "plugins.enumerable_names" = "";

            # Use Mozilla instead of Google here.
            "geo.provider.network.url" =
              "https://location.services.mozilla.com/v1/geolocate?key=%MOZILLA_API_KEY%";

            # No speculative content when searching.
            "browser.urlbar.speculativeConnect.enabled" = false;

            # Sends data to servers when leaving pages.
            "beacon.enabled" = false;

            # Informs servers about links that get clicked on by the user.
            "browser.send_pings" = false;

            "browser.tabs.closeWindowWithLastTab" = false;
            "browser.urlbar.placeholderName" = "DuckDuckGo";
            "browser.search.defaultenginename" = "DuckDuckGo";

            # Firefox experiments...
            "experiments.activeExperiment" = false;
            "experiments.enabled" = false;
            "experiments.supported" = false;
            "extensions.pocket.enabled" = false;

            # Privacy
            "privacy.donottrackheader.enabled" = true;
            "privacy.donottrackheader.value" = 1;
            "privacy.trackingprotection.enabled" = true;
            "privacy.trackingprotection.socialtracking.enabled" = true;
            "privacy.firstparty.isolate" = true;
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
            "toolkit.telemetry.enabled" = false;
            "toolkit.telemetry.unified" = false;
            "toolkit.telemetry.archive.enabled" = false;
            "browser.toolbars.bookmarks.visibility" = "never";

            # Perf
            "gfx.webrender.all" = true;
            "media.ffmpeg.vaapi.enabled" = true;
            "media.ffvpx.enabled" = false;
            "media.rdd-vpx.enabled" = false;
            "gfx.webrender.compositor.force-enabled" = true;

            # Remove those extra empty spaces in both sides
            "browser.uiCustomization.state" = ''
              {"placements":{"widget-overflow-fixed-list":[],"nav-bar":["back-button","forward-button","stop-reload-button","urlbar-container","downloads-button","fxa-toolbar-menu-button"],"toolbar-menubar":["menubar-items"],"TabsToolbar":["tabbrowser-tabs","new-tab-button","alltabs-button"],"PersonalToolbar":["import-button","personal-bookmarks"]},"seen":["developer-button"],"dirtyAreaCache":["nav-bar","PersonalToolbar"],"currentVersion":17,"newElementCount":4}
            '';
          };
        };
      };
    };

    tmux = {
      enable = true;
      clock24 = true;
      extraConfig = ''
        set -ga terminal-overrides ',xterm-256color:Tc'
      '';
      plugins = with pkgs.tmuxPlugins; [{
        plugin = tmux-colors-solarized;
        extraConfig = ''
          set -g @colors-solarized 'dark' 
        '';
      }];
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
        replaygain = { backend = "gstreamer"; };
        import = { move = true; };
        fetchart = { auto = true; };
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
        env = { TERM = "xterm-256color"; };
        scrolling = { history = 100000; };
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
