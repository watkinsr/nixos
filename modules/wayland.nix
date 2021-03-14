{ config, lib, pkgs, inputs, nixpkgs, ... }:

{
  boot.kernelModules = [ "v4l2loopback" ];

  nixpkgs.overlays = [
    (import inputs.nixpkgs-wayland)
  ];

  services.xserver = {
    displayManager = {
      gdm.wayland = true;
    };
  };

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
      ];
      gtkUsePortal = true;
    };
  };

  environment = {
    pathsToLink = [ "/libexec" ];
    systemPackages = with pkgs; [
      linuxPackages.v4l2loopback
      xwayland
      firefox-wayland
      polkit_gnome
      waybar
      swaylock
      swayidle
      wl-clipboard
      mako
      wofi
      kanshi
      wev
      wf-recorder
      wl-clipboard
    ];
  };
}
