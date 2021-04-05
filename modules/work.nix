{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
     jetbrains.datagrip
     google-cloud-sdk
     jetbrains.idea-community
     master.zoom-us
     slack
  ];
}
