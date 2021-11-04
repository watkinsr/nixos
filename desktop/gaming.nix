{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    lutris
  ];

  programs = {
    steam.enable = true;
  };

  hardware = {
    opengl = {
      driSupport32Bit = true;
      enable = true;
    };
  };
}
