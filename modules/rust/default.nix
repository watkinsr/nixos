{ config, lib, pkgs, nixpkgs, home-manager, ... }:

{
  environment.systemPackages = with pkgs; [
    binutils
    cargo-bloat
    cargo-watch
    clang
    evcxr
    rust-analyzer
    rust-bin.stable.latest.default
  ];
}
