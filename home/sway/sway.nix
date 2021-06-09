{ lib, ... }:

let
  modifier = "Mod4";
  terminal = "alacritty";
  menu = "wofi --show run";

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
  modifier = modifier;
  terminal = terminal;
  menu = menu;
  workspaceAutoBackAndForth = true;

  fonts = {
    names = [ "pango:Hack" "FontAwesome" ];
    size = 12.0;
  };

  output = {
    "DP-2" = {
      bg = "~/.config/pictures/85kpazrfhbv61.png fill";
      pos = "0 0 res 5120x1440";
      adaptive_sync = "off";
    };
    "eDP-1" = {
      bg = "~/.config/pictures/TNEJezP.jpg fill";
      scale = "1.0";
    };
  };

  input = {
    "*" = {
      xkb_layout = "us,fi";
      xkb_options = "compose:ralt,ctrl:nocaps";
    };
  };

  colors = {
    focused = {
      border = black;
      background = yellow;
      text = black;
      indicator = darkblack;
      childBorder = darkblack;
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
    chat = {
      Escape = "mode default";
      e = ''exec --no-startup-id "element-desktop --enable-features=UseOzonePlatform --ozone-platform=wayland"'';
      s = ''exec --no-startup-id "slack --enable-features=UseOzonePlatform --ozone-platform=wayland"'';
    };
  };

  keybindings = lib.mkOptionDefault {
    "${modifier}+Return" = "exec ${terminal}";
    "${modifier}+q" = "kill";
    "${modifier}+d" = "exec ${menu}";
    "${modifier}+Shift+c" = "reload";
    "${modifier}+c" = ''mode "chat"'';
    "${modifier}+r" = ''mode "resize"'';
    "${modifier}+z" = ''exec --no-startup-id "emacsclient -nc"'';
    "${modifier}+n" = ''exec --no-startup-id "makoctl dismiss"'';
    "${modifier}+Shift+n" = ''exec --no-startup-id "makoctl dismiss --all"'';
    "${modifier}+Print" = ''exec grim -t png -g "$(slurp)" ~/Downloads/$(date +%Y-%m-%d_%H-%m-%s).png'';

    "Mod1+Control+l" = ''exec --no-startup-id wlogout'';
  };

  floating = {
    criteria = [
      { class = "SpeedCrunch"; }
    ];
  };

  bars = [
    {
      command = "waybar";
    }
  ];
}
