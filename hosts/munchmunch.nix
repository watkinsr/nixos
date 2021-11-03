{ config, lib, pkgs, modulesPath, inputs, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ../modules/minimal.nix
    ../modules/common.nix
    ../modules/fonts.nix
    ../modules/dev.nix
    ../modules/multimedia.nix
    ../modules/work.nix
    ../modules/wayland.nix
    ../modules/home-services.nix
  ];

  time.timeZone = "Europe/Berlin";

  services.sshd.enable = true;

  home-manager.users.pimeys = {
    wayland.windowManager.sway = {
      config = { output = { "*" = { scale = "1.5"; }; }; };
    };
  };

  boot.initrd.availableKernelModules =
    [ "xhci_pci" "ahci" "nvme" "usb_storage" "uas" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "zroot/root/nixos";
    fsType = "zfs";
  };

  fileSystems."/home" = {
    device = "zroot/home";
    fsType = "zfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/9DEB-2857";
    fsType = "vfat";
  };

  swapDevices = [ ];

  hardware.video.hidpi.enable = lib.mkDefault true;

  networking = {
    interfaces = { enp5s0.useDHCP = true; };

    hostId = "CC221B18";
    hostName = "munchmunch";
  };
}
