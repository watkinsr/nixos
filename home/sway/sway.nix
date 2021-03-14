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

  fonts = [ "pango:Hack" "FontAwesome 12" ];

  output = {
    "*" = {
      bg = "~/.config/nixpkgs/home/pictures/TNEJezP.jpg fill";
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

  keybindings = lib.mkOptionDefault {
    "${modifier}+Return" = "exec ${terminal}";
    "${modifier}+q" = "kill";
    "${modifier}+d" = "exec ${menu}";
    "${modifier}+Shift+c" = "reload";
    "${modifier}+z" = ''exec --no-startup-id "emacsclient -nc"'';
    "${modifier}+n" = ''exec --no-startup-id "makoctl dismiss"'';
    "${modifier}+Shift+n" = ''exec --no-startup-id "makoctl dismiss --all"'';

    "Mod1+Control+l" = "mode power";
  };

  modes = {
    power = {
      l = ''mode default, exec --no-startup-id swaylock -i ~/.config/nixpkgs/home/pictures/Ve0XkQ4.jpg'';
      e = ''mode default, exec --no-startup-id swaymsg exit'';
      s = ''mode default, exec --no-startup-id systemctl suspend'';
      h = ''mode default, exec --no-startup-id systemctl hibernate'';
      r = ''mode default, exec --no-startup-id systemctl reboot'';
      p = ''mode default, exec --no-startup-id systemctl poweroff'';

      Return = "mode default";
      Escape = "mode default";
    };
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
