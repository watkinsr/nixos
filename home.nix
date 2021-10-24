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
      chromium = {
        name = "Ungoogled Chromium";
        genericName = "Web Browser";
        exec = ''
          chromium \
                    --enable-features=UseOzonePlatform,VaapiVideoDecoder \
                    --ozone-platform=wayland \
                    --ignore-gpu-blocklist \
                    --enable-gpu-rasterization \
                    --enable-zero-copy'';
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

    chromium = {
      enable = true;
      package = pkgs.master.ungoogled-chromium;
      extensions = let
        createChromiumExtensionFor = browserVersion:
          { id, sha256, version }: {
            inherit id;
            crxPath = builtins.fetchurl {
              url =
                "https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx2,crx3&prodversion=${browserVersion}&x=id%3D${id}%26installsource%3Dondemand%26uc";
              name = "${id}.crx";
              inherit sha256;
            };
            inherit version;
          };
        createChromiumExtension = createChromiumExtensionFor
          (lib.versions.major pkgs.ungoogled-chromium.version);
      in [
        (createChromiumExtension {
          # nord theme
          id = "cnfjnjfppmpabbbdeijhimfijipmmanj";
          sha256 =
            "sha256:1xl4ka95lsisdzfciiwizr4bfsxz9vs0hnfimmm5scpykvnm3m4k";
          version = "1.0";
        })
        (createChromiumExtension {
          # ublock origin
          id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";
          sha256 =
            "sha256:12ps948lg91bbjxjmwb3d8590q8rf4mv7bkhzrjnnd210gbl5wxn";
          version = "1.38.6";
        })
        (createChromiumExtension {
          # autoscroll
          id = "occjjkgifpmdgodlplnacmkejpdionan";
          sha256 =
            "sha256:1mcmfgl046sjldrz2fm4kwgfg017hw2hy6zkpak6hrl8zwi4fli5";
          version = "4.10";
        })
        (createChromiumExtension {
          # bitwarden
          id = "nngceckbapebfimnlniiiahkandclblb";
          sha256 =
            "sha256:0dh64lzbgki501v83fhlzvd5jnxpa6kqy386jp6xvm3607by1xpx";
          version = "1.53.0";
        })
        (createChromiumExtension {
          # ninja cookie
          id = "jifeafcpcjjgnlcnkffmeegehmnmkefl";
          sha256 =
            "sha256:0lnl6qgybznzi28vjxw6yy84gvcfafhwghlv3xs20610p3h8l8wp";
          version = "0.7.0";
        })
        (createChromiumExtension {
          # decentraleyes
          id = "ldpochfccmkkmhdbclfhpagapcfdljkj";
          sha256 =
            "sha256:0cmkc01z06sw8rarsy9w1v6lpw2r39ad14m7b80bcgmfbxbh0ind";
          version = "2.0.16";
        })
        (createChromiumExtension {
          # zoom redirector
          id = "fmaeeiocbalinknpdkjjfogehkdcbkcd";
          sha256 =
            "sha256:0lmdamqm1p4sh454bha3f9h49q0gnig1yr6qm5z1rzlsivmwhfbn";
          version = "1.0.2";
        })
        (createChromiumExtension {
          # clearurls
          id = "lckanjgmijmafbedllaakclkaicjfmnk";
          sha256 =
            "sha256:004skr65b7jljm6w4znpgp7ys8h2cvbald73k5lgajrci92yz7f9";
          version = "1.21.0";
        })
        (createChromiumExtension {
          # unpaywall
          id = "iplffkdpngmdjhlpjmppncnlhomiipha";
          sha256 =
            "sha256:19qrhyha3jsjw992x843b6l56psd3dvhs17haq9r3gq7wa6m2rwb";
          version = "3.98";
        })
        (createChromiumExtension {
          # old reddit redirect
          id = "dneaehbmnbhcippjikoajpoabadpodje";
          sha256 =
            "sha256:0y0g3f5zcmc5d1689znikcpp8rl4bxm0qc509xrz5abanv6h60s3";
          version = "1.5.1";
        })
      ];
    };

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
        h264ify
      ];
      profiles = {
        default = {
          isDefault = true;
          settings = {
            # Do not save passwords to Firefox...
            "security.ask_for_password" = 2;

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

            # Safe browsing
            "browser.safebrowsing.enabled" = false;
            "browser.safebrowsing.phishing.enabled" = false;
            "browser.safebrowsing.malware.enabled" = false;
            "browser.safebrowsing.downloads.enabled" = false;
            "browser.safebrowsing.provider.google4.updateURL" = "";
            "browser.safebrowsing.provider.google4.reportURL" = "";
            "browser.safebrowsing.provider.google4.reportPhishMistakeURL" = "";
            "browser.safebrowsing.provider.google4.reportMalwareMistakeURL" =
              "";
            "browser.safebrowsing.provider.google4.lists" = "";
            "browser.safebrowsing.provider.google4.gethashURL" = "";
            "browser.safebrowsing.provider.google4.dataSharingURL" = "";
            "browser.safebrowsing.provider.google4.dataSharing.enabled" = false;
            "browser.safebrowsing.provider.google4.advisoryURL" = "";
            "browser.safebrowsing.provider.google4.advisoryName" = "";
            "browser.safebrowsing.provider.google.updateURL" = "";
            "browser.safebrowsing.provider.google.reportURL" = "";
            "browser.safebrowsing.provider.google.reportPhishMistakeURL" = "";
            "browser.safebrowsing.provider.google.reportMalwareMistakeURL" = "";
            "browser.safebrowsing.provider.google.pver" = "";
            "browser.safebrowsing.provider.google.lists" = "";
            "browser.safebrowsing.provider.google.gethashURL" = "";
            "browser.safebrowsing.provider.google.advisoryURL" = "";
            "browser.safebrowsing.downloads.remote.url" = "";

            # Don't call home on new tabs
            "browser.selfsupport.url" = "";
            "browser.aboutHomeSnippets.updateUrL" = "";
            "browser.startup.homepage_override.mstone" = "ignore";
            "browser.startup.homepage_override.buildID" = "";
            "startup.homepage_welcome_url" = "";
            "startup.homepage_welcome_url.additional" = "";
            "startup.homepage_override_url" = "";

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
            "media.navigator.mediadatadecoder_vpx_enabled" = true;

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
