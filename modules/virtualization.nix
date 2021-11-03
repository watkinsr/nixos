{ config, lib, pkgs, ... }:

{
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        ovmf.enable = true;
        runAsRoot = false;
      };
      onBoot = "ignore";
      onShutdown = "shutdown";
    };
  };

  programs.dconf.enable = true;
  environment.systemPackages = with pkgs; [ virt-manager ];
}
