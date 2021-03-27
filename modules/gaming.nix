{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    steam
    lutris
  ];

  hardware.opengl.driSupport32Bit = true;
}
