{ config, pkgs, lib, ... }:

{
  boot = {
    kernelModules = [ "v4l2loopback" ];
    extraModulePackages = with pkgs; [ config.boot.kernelPackages.v4l2loopback.out ];
  };

  home-manager.users.pimeys = {
    programs.obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    pulseaudio
    pavucontrol
    zoom-us
    ffmpeg-full
    v4l-utils
    qjackctl
    helvum
  ];
}
