{ pkgs, ... }:

let
  doom-emacs = pkgs.callPackage (builtins.fetchTarball {
    url = https://github.com/vlaci/nix-doom-emacs/archive/master.tar.gz;
  }) {
    doomPrivateDir = ./home/doom.d;  # Directory containing your config.el init.el
                                     # and packages.el files
  };
in {
  home.packages = [ doom-emacs ];
  home.file.".emacs.d/init.el".text = ''
      (load "default.el")
  '';
  programs = {
    git = {
      enable = true;
      userName = "Julius de Bruijn";
      userEmail = "julius@nauk.io";
      aliases = {
        co = "checkout";
        br = "branch";
        st = "status";
        ci = "commit";
      };
    };
    fish = {
      enable = true;
      interactiveShellInit = ''
        set PATH ~/.cargo/bin ~/.local/bin $PATH
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
          move = "yes";
        };
        fetchart = {
          auto = "yes";
        };
        convert = {
          auto = "no";
          threads = 4;
          copy_album_art = "yes";
          embed = "yes";
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
        colors = {
          primary = {
            background = "0x002635";
            foreground = "0xe6e6dc";
          };
          normal = {
            black = "0x00384d";
            red = "0xc43061";
            green = "0x7fc06e";
            yellow = "0xf08e48";
            blue = "0x1c8db2";
            magenta = "0xc694ff";
            cyan = "0x00cccc";
            white = "0x77929e";
          };
          bright = {
            black = "0x517f8d";
            red = "0xff5a67";
            green = "0x9cf087";
            yellow = "0xffcc1b";
            blue = "0x7eb2dd";
            magenta = "0xfb94ff";
            cyan = "0x00ffff";
            white = "0xb7cff9";
          };
          cursor = {
            text = "0x002635";
            cursor = "0xffcc1b";
          };
        };
      };
    };
  };

  xdg.configFile = {
    "sway/config".source = ./home/sway/config;
    "wofi/style.css".source = ./home/wofi/style.css;
    "i3blocks/config".source = ./home/i3blocks/config;
    "i3blocks/i3status.conf".source = ./home/i3blocks/i3status.conf;
    "i3blocks/scripts/battery.sh".source = ./home/i3blocks/scripts/battery.sh;
    "i3blocks/scripts/cpu.pl".source = ./home/i3blocks/scripts/cpu.pl;
    "i3blocks/scripts/memory.sh".source = ./home/i3blocks/scripts/memory.sh;
    "i3blocks/scripts/temperature.sh".source = ./home/i3blocks/scripts/temperature.sh;
    "i3blocks/scripts/wifi.sh".source = ./home/i3blocks/scripts/wifi.sh;
  };
}
