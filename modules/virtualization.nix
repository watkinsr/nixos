{ config, lib, pkgs, ... }:

{
  virtualisation = {
    libvirtd = {
      enable = true;
      qemuOvmf = true;
      qemuRunAsRoot = false;
      onBoot = "ignore";
      onShutdown = "shutdown";
    };
  };

  programs.dconf.enable = true;
  users.extraGroups.vboxusers.members = [ "pimeys" ];
  environment.systemPackages = with pkgs; [ virt-manager ];
}
