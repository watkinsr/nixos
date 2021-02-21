{ config, lib, pkgs, ... }:

let
  hass-token = import ../secret/hass-token.nix;
  home-coords = import ../secret/home-coords.nix;
in {
  programs.dconf.enable = true;
  services.xserver = {
    enable = true;

    desktopManager = {
      xterm.enable = false;
    };

    displayManager = {
        defaultSession = "none+i3";
    };

    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      extraPackages = with pkgs; [
        rofi
        i3status
        i3lock
        i3blocks-gaps
        feh
        dunst
        scrot
        imagemagick
        xorg.xinput
        xorg.setxkbmap
        xorg.xset
        xorg.xrdb
     ];
      extraSessionCommands = ''
        export HASS_SERVER="http://hass.local:8123";
        export HASS_TOKEN=${hass-token};
        export HOME_COORDS=${home-coords};
      '';
    };
  };
}
