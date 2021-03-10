{ config, lib, pkgs, inputs, nixpkgs, ... }:

{
  virtualisation.docker.enable = true;
  services.lorri.enable = true;

  nixpkgs.overlays = [
    (import inputs.emacs)

    (self: super: with super; {
       emacs-wayland = pkgs.emacsPgtk;
    })
  ];

  environment.systemPackages = with pkgs; [
     neovim
     git
     perl
     clang
     binutils
     zlib
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
