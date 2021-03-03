{ config, lib, pkgs, inputs, ... }:

let
  master = import inputs.nixpkgs-master {};
in {
  nixpkgs.overlays = [
    (self: super: {
      waybar = master.waybar;
    })
  ];

  boot.kernelModules = [ "v4l2loopback" ];

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true; # so that gtk works properly
    extraPackages = with pkgs; [
      xwayland
      swaylock
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
    ];
    extraSessionCommands = ''
      export _JAVA_AWT_WM_NONREPARENTING=1;
      export SDL_VIDEODRIVER=wayland
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      export HASS_SERVER="http://hass.local:8123";
      export MOZ_ENABLE_WAYLAND="1";
      export XDG_SESSION_TYPE="wayland";
      source $HOME/.config/nixpkgs/secret/secret;
    '';
  };

  services.xserver.displayManager.gdm.wayland = true;

  environment.systemPackages = with pkgs; [
     wl-clipboard
  ];
}
