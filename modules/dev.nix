{ config, lib, pkgs, nixpkgs, home-manager, ... }:

{
  virtualisation = {
    docker.enable = true;
  };

  environment.systemPackages = with pkgs; [
    emacsPgtkGcc
    ansible
    neovim
    git
    gdb
    perl
    clang
    binutils
    zlib
    ripgrep
    xsv
    exa
    dust
    fd
    openjdk
    android-studio
    jq
    nodejs-slim
    nodePackages.npm
    starship
    docker-compose
    python3
    rust-analyzer
    rust-bin.stable.latest.default
    cargo-watch
    cargo-bloat
    mysql-client
    postgresql_12
    gnumake
    evcxr
    valgrind
    massif-visualizer
  ];
}
