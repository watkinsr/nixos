{ config, lib, pkgs, nixpkgs, home-manager, ... }:

{
  virtualisation = { docker.enable = true; };
  environment.systemPackages = with pkgs; [ docker-compose ];
}
