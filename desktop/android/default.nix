{ config, lib, pkgs, nixpkgs, home-manager, ... }:

{
  programs.adb.enable = true;
  environment.systemPackages = with pkgs; [ android-studio ];
}
