{ config, lib, pkgs, inputs, nixpkgs, ... }:

{
  boot.kernelModules = [ "v4l2loopback" ];

  nixpkgs.overlays = [
    (import inputs.mozilla)

    (self: super: with super; {
      firefox-nightly-bin = latest.firefox-nightly-bin;
    })
  ];

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
      firefox-nightly-bin
      polkit_gnome
    ];
  };
}
