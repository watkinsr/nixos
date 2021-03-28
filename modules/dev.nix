{ config, lib, pkgs, inputs, nixpkgs, ... }:

{
  virtualisation = {
    docker.enable = true;
  };

  environment.systemPackages = with pkgs; [
    ansible
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
    rust-bin.stable.latest.rust
    rust-bin.stable.latest.rust-src
    rust-bin.stable.latest.cargo
    cargo-watch
    cargo-bloat
  ];
}
