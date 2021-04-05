{ config, lib, pkgs, nixpkgs, home-manager, ... }:

{
  virtualisation = {
    docker.enable = true;
  };

  environment.systemPackages = with pkgs; [
    ansible
    neovim
    git
    gdb
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
    nodePackages.npm
    starship
    docker-compose
    python3
    rust-analyzer
    rust-bin.stable.latest.rust
    rust-bin.stable.latest.rust-src
    rust-bin.stable.latest.cargo
    cargo-watch
    cargo-bloat
    mysql-client
    postgresql_12
  ];
}
