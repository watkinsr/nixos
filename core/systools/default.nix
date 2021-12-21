{ pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    bat
    bc
    bind
    exa
    fd
    btop
    htop
    jq
    mc
    ranger
    ripgrep
    sysstat
    thefuck
    tree
    unzip
    wget
    xsv
    zip
    zstd
    file
  ];
}
