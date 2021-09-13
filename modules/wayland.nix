{ config, lib, pkgs, inputs, nixpkgs, home-manager, ... }:

{
  home-manager.users.pimeys = {
    home.sessionVariables = {
      MOZ_ENABLE_WAYLAND = 1;
      XDG_SESSION_TYPE = "wayland";
    };

    wayland = {
      windowManager.sway = {
        enable = true;
        config = import ../home/sway/sway.nix {
          lib = lib;
        };
        wrapperFeatures.gtk = true;
        extraSessionCommands = ''
          export _JAVA_AWT_WM_NONREPARENTING=1;
          export SDL_VIDEODRIVER=wayland;
          export QT_QPA_PLATFORM=wayland;
          export QT_WAYLAND_DISABLE_WINDOWDECORATION="1";
          export HASS_SERVER="http://hass.local:8123";
          export MOZ_ENABLE_WAYLAND="1";
          export MOZ_DBUS_REMOTE="1";
          export XDG_SESSION_TYPE="wayland";
          export XDG_CURRENT_DESKTOP="sway";
          export MC_SKIN=$HOME/.config/mc/selenized.ini;
          source /etc/nixos/secret/secret;
        '';
        extraConfig = ''
          exec --no-startup-id systemctl --user import-environment DISPLAY WAYLAND_DISPLAY SWAYSOCK XDG_SESSION_TYPE XDG_SESSION_DESKTOP XDG_CURRENT_DESKTOP
          exec --no-startup-id systemctl --user restart emacs.service &
          exec --no-startup-id mako &
          exec --no-startup-id swayidle -w timeout 600 'swaymsg "output * dpms off"' resume 'swaymsg "output * dpms on"'
        '';
      };
    };

    programs = {
      mako = {
        enable = true;
      };
      waybar = {
        enable = true;
        settings = import ../home/waybar/waybar.nix;
        style = "${builtins.readFile ../home/waybar/style.css}";
      };
      foot = {
        enable = true;
        server.enable = true;
        settings = {
          main = {
            term = "xterm-256color";
            font = "Inconsolata:size=12";
          };
          cursor = {
            color = "002b36 93a1a1";
          };
          colors = {
            alpha      = 0.9;
            background = "103c48";
            foreground = "adbcbc";

            regular0 = "184956";
            regular1 = "fa5750";
            regular2 = "75b938";
            regular3 = "dbb32d";
            regular4 = "4695f7";
            regular5 = "f275be";
            regular6 = "41c7b9";
            regular7 = "72898f";

            bright0 = "2d5b69";
            bright1 = "ff665c";
            bright2 = "84c747";
            bright3 = "ebc13d";
            bright4 = "58a3ff";
            bright5 = "ff84cd";
            bright6 = "53d6c7";
            bright7 = "cad8d9";
          };
        };
      };
    };
  };

  boot.kernelModules = [ "v4l2loopback" ];

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true; # so that gtk works properly
    extraPackages = with pkgs; [
      brillo
      xwayland
      swaylock-effects
      swayidle
      wl-clipboard
      mako # notification daemon
      wofi
      waybar
      kanshi
      i3blocks-gaps
      i3status
      wev
      wf-recorder
      linuxPackages.v4l2loopback
      slurp
      wlogout
      grim
    ];
  };

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
      gtkUsePortal = true;
    };
  };

  services.xserver = {
    displayManager = {
      defaultSession = "sway";
      gdm.wayland = true;
    };
  };

  environment = {
    pathsToLink = [ "/libexec" ];
    systemPackages = with pkgs; [
      firefox-wayland
      polkit_gnome
    ];
  };

  systemd.services.lock-before-sleeping = {
    restartIfChanged = false;
    unitConfig = {
      Description = "Helper service to bind locker to sleep.target";
    };
    serviceConfig = {
      ExecStart = "${pkgs.swaylock-effects}/bin/swaylock --screenshots --clock --indicator --indicator-radius 100 --indicator-thickness 7 --effect-blur 7x5 --effect-vignette 0.5:0.5 --ring-color bb00cc --key-hl-color 880033 --line-color 00000000 --inside-color 00000088 --separator-color 00000000 --grace 2 --fade-in 0.2";
      Type = "simple";
      User = "pimeys";
    };
    before = [
      "pre-sleep.service"
    ];
    wantedBy= [
      "pre-sleep.service"
    ];
    environment = {
      DISPLAY = ":1";
      WAYLAND_DISPLAY = "wayland-1";
      XDG_RUNTIME_DIR = "/run/user/1000";
    };
  };
}
