{ config, lib, pkgs, nixpkgs, home-manager, ... }:

{
  environment.systemPackages = with pkgs; [
    nodejs-slim
    nodePackages.npm
    nodePackages.typescript
    nodePackages.typescript-language-server
    master.nodePackages.prisma
  ];
}
