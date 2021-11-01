{ config, lib, pkgs, inputs, nixpkgs, home-manager, ... }:

{
  imports = [ ../home/waybar ../home/sway ];

  home-manager.users.pimeys = {
    home.sessionVariables = {
      MOZ_ENABLE_WAYLAND = 1;
      XDG_SESSION_TYPE = "wayland";
    };

    programs = {
      mako = { enable = true; };
      foot = {
        enable = true;
        server.enable = true;
        settings = {
          main = {
            term = "xterm-256color";
            font = "Inconsolata:size=14";
          };
          cursor = { color = "002b36 93a1a1"; };
          colors = {
            alpha = 1;
            #background = "103c48";
            background = "002B36";
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

  environment = {
    pathsToLink = [ "/libexec" ];
    systemPackages = with pkgs; [
      polkit_gnome
      brillo
      xwayland
      swaylock-effects
      swayidle
      wl-clipboard
      wofi
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

  systemd.services.lock-before-sleeping = {
    restartIfChanged = false;
    unitConfig = {
      Description = "Helper service to bind locker to sleep.target";
    };
    serviceConfig = {
      ExecStart =
        "${pkgs.swaylock-effects}/bin/swaylock --screenshots --clock --indicator --indicator-radius 100 --indicator-thickness 7 --effect-blur 7x5 --effect-vignette 0.5:0.5 --ring-color bb00cc --key-hl-color 880033 --line-color 00000000 --inside-color 00000088 --separator-color 00000000 --grace 2 --fade-in 0.2";
      Type = "simple";
      User = "pimeys";
    };
    before = [ "pre-sleep.service" ];
    wantedBy = [ "pre-sleep.service" ];
    environment = {
      DISPLAY = ":1";
      WAYLAND_DISPLAY = "wayland-1";
      XDG_RUNTIME_DIR = "/run/user/1000";
    };
  };
}
