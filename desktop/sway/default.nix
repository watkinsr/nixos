{ lib, home-manager, pkgs, ... }:

let
  modifier = "Mod4";
  terminal = "footclient";
  menu = "wofi --show drun";

  darkred = "#cc241d";
  red = "#fb4934";
  darkgreen = "#98971a";
  green = "#b8bb26";
  darkyellow = "#d79921";
  yellow = "#fabd2f";
  darkblue = "#458588";
  blue = "#83a598";
  darkmagenta = "#b16286";
  magenta = "#d3869b";
  darkcyan = "#689d6a";
  darkwhite = "#a89984";
  cyan = "#8ec07c";
  white = "#ebdbb2";
  black = "#073642";
  darkblack = "#002b36";
  transparent = "#00000000";

  height = 34;

  default-gaps-inner = 0;
  default-gaps-outer = 0;
in {
  programs.sway = { enable = true; };

  home-manager.users.ryan = {
    wayland.windowManager.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      extraSessionCommands = with pkgs; ''
        export _JAVA_AWT_WM_NONREPARENTING=1;
        export SDL_VIDEODRIVER=x11;
        export QT_QPA_PLATFORM=wayland;
        export QT_WAYLAND_DISABLE_WINDOWDECORATION="1";
        export MOZ_ENABLE_WAYLAND="1";
        export MOZ_DBUS_REMOTE="1";
        export XDG_SESSION_TYPE="wayland";
        export XDG_CURRENT_DESKTOP="sway";
        export MC_SKIN=$HOME/.config/mc/selenized.ini;
        export XDG_DATA_DIRS="${gnome3.adwaita-icon-theme}/share:$XDG_DATA_DIRS";
      '';
      extraConfig = ''
        exec --no-startup-id systemctl --user import-environment DISPLAY WAYLAND_DISPLAY SWAYSOCK XDG_SESSION_TYPE XDG_SESSION_DESKTOP XDG_CURRENT_DESKTOP
        exec --no-startup-id mako &
        exec --no-startup-id swayidle -w timeout 600 'swaymsg "output * dpms off"' resume 'swaymsg "output * dpms on"'
      '';
      config = {
        modifier = modifier;
        terminal = terminal;
        menu = menu;
        workspaceAutoBackAndForth = true;

        fonts = {
          names = [ "pango:Hack" "FontAwesome" ];
          size = 12.0;
        };

        output = { "*" = { bg = "~/.config/pictures/TNEJezP.jpg fill"; }; };

        input = {
          "*" = {
            xkb_layout = "watkinsr";
            repeat_delay = "350";
            repeat_rate = "55";
          };
        };

        colors = {
          focused = {
            border = yellow;
            background = yellow;
            text = black;
            indicator = darkblack;
            childBorder = yellow;
          };
          unfocused = {
            border = black;
            background = black;
            text = white;
            indicator = darkblack;
            childBorder = darkblack;
          };
          focusedInactive = {
            border = black;
            background = black;
            text = white;
            indicator = darkblack;
            childBorder = darkblack;
          };
          urgent = {
            border = darkred;
            background = darkred;
            text = black;
            indicator = darkred;
            childBorder = darkred;
          };
          background = black;
        };

        gaps = {
          inner = 0;
          outer = 0;
        };

        modes = {
          resize = {
            Left = "resize shrink width 10 px or 1 ppt";
            Down = "resize grow height 10 px or 1 ppt";
            Up = "resize shrink height 10 px or 1 ppt";
            Right = "resize grow width 10 px or 1 ppt";
            Return = ''mode "default"'';
            Escape = ''mode "default"'';

            "Shift+Left" = "resize shrink width 20 px or 5 ppt";
            "Shift+Down" = "resize grow height 20 px or 5 ppt";
            "Shift+Up" = "resize shrink height 20 px or 5 ppt";
            "Shift+Right" = "resize grow width 20 px or 5 ppt";
          };
        };

        keybindings = lib.mkOptionDefault {
          "${modifier}+Return" = "exec ${terminal}";
          "${modifier}+q" = "kill";
          "${modifier}+d" = "exec ${menu}";
          "${modifier}+Shift+c" = "reload";
          "${modifier}+c" = ''mode "chat"'';
          "${modifier}+r" = ''mode "resize"'';
          "${modifier}+n" = ''exec --no-startup-id "makoctl dismiss"'';
          "${modifier}+Shift+n" =
            ''exec --no-startup-id "makoctl dismiss --all"'';
          "${modifier}+Print" = ''
            exec grim -t png -g "$(slurp)" ~/Downloads/$(date +%Y-%m-%d_%H-%m-%s).png'';
          "${modifier}+i" = "exec brillo -U 10";
          "${modifier}+o" = "exec brillo -A 10";
          "${modifier}+z" = "exec emacsclient -nc ~/.config/nixpkgs";

          "Mod1+Control+l" = "exec --no-startup-id wlogout";
        };

        floating = { criteria = [{ class = "SpeedCrunch"; }]; };

        bars = [{ command = "waybar"; }];
      };
    };
  };
}
