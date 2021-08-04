{ config, lib, pkgs, nixpkgs, home-manager, ... }:

{
  virtualisation = {
    docker.enable = true;
  };

  programs.adb.enable = true;

  environment.systemPackages = with pkgs; [
    android-studio
    ansible
    binutils
    cargo-bloat
    cargo-watch
    clang
    docker-compose
    evcxr
    gdb
    git
    gnumake
    massif-visualizer
    mysql-client
    neovim
    nodejs-slim
    nodePackages.npm
    openjdk
    perl
    postgresql_12
    python3
    ripgrep
    rust-analyzer
    rust-bin.stable.latest.default
    valgrind
    zlib
    master.pscale
    fzf
  ];
}
