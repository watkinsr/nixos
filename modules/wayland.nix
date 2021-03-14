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
    extraSessionCommands = ''
      export _JAVA_AWT_WM_NONREPARENTING=1;
      export SDL_VIDEODRIVER=wayland
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      export HASS_SERVER="http://hass.local:8123";
      export MOZ_ENABLE_WAYLAND="1";
      export XDG_SESSION_TYPE="wayland";
      export XDG_CURRENT_DESKTOP="sway";
      source $HOME/.config/nixpkgs/secret/secret;
    '';
  };

  services.xserver.displayManager.gdm.wayland = true;

  environment = {
    pathsToLink = [ "/libexec" ];
    systemPackages = with pkgs; [
      wl-clipboard
      firefox-nightly-bin
      polkit_gnome
    ];
  };
}
