{ config, lib, pkgs, inputs, ... }:

{
  virtualisation.docker.enable = true;
  services.lorri.enable = true;

  environment.systemPackages = with pkgs; [
     neovim
     emacs
     git
     perl
     rustup
     clang
     binutils
     zlib
     openssl
     automake
     gnumake
     rust-analyzer
     ripgrep
     fd
     openjdk
     android-studio
     jq
     nodejs-slim
     starship
     docker-compose
     python3
  ];
}
