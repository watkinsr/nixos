{ config, lib, pkgs, ... }:

{
  virtualisation = {
    libvirtd.enable = true;
    virtualbox.host = {
      enable = true;
      enableExtensionPack = true;
    };
  };

  programs.dconf.enable = true;
  users.extraGroups.vboxusers.members = [ "pimeys" ];
  environment.systemPackages = with pkgs; [ virt-manager ];
}
