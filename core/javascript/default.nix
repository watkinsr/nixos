{ config, lib, pkgs, nixpkgs, home-manager, ... }:

{
  environment.systemPackages = with pkgs; [
    nodejs-slim
    nodePackages.npm
    nodePackages.typescript
    nodePackages.typescript-language-server
    prisma37.nodePackages.prisma
    lsp.nodePackages."@prisma/language-server"
  ];
}
