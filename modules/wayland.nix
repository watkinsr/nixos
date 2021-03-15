{ config, lib, pkgs, inputs, nixpkgs, ... }:

{
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
      wl-clipboard
      firefox-wayland
      polkit_gnome
    ];
  };
}
