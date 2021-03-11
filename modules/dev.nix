{ config, lib, pkgs, inputs, nixpkgs, ... }:

{
  virtualisation.docker.enable = true;
  services.lorri.enable = true;

  nixpkgs.overlays = [
    (import inputs.emacs)
    (import inputs.rust-overlay)

    (self: super: with super; {
       dune = super.dune_1; # see: https://github.com/vlaci/nix-doom-emacs/issues/166
       emacs-wayland = pkgs.emacsPgtk;
       rust-latest = rust-bin.stable.latest.rust;
       rust-src-latest = rust-bin.stable.latest.rust-src;
       cargo-latest = rust-bin.stable.latest.cargo;
    })
  ];

  environment.systemPackages = with pkgs; [
     neovim
     git
     perl
     clang
     binutils
     zlib
     ripgrep
     fd
     openjdk
     android-studio
     jq
     nodejs-slim
     starship
     docker-compose
     python3
     rust-analyzer
     rust-latest
     rust-src-latest
     cargo-latest
  ];
}
