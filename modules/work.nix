{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
     jetbrains.datagrip
     google-cloud-sdk
     jetbrains.idea-community
     slack
     zoom-us
  ];
}
