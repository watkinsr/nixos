{ config, lib, pkgs, nixpkgs, home-manager, ... }:

{
  environment.systemPackages = with pkgs; [
    mysql-client
    postgresql_12
    sqlite-interactive
  ];
}
