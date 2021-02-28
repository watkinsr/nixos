{ config, lib, pkgs, inputs, ... }:

let
     neovim-nightly = inputs.neovim-nightly.defaultPackage."${pkgs.system}";
in {
  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [
     neovim-nightly
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
