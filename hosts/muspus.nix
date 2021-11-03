{ config, lib, pkgs, modulesPath, inputs, ... }:

{
  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t470s
    (modulesPath + "/installer/scan/not-detected.nix")
    ../modules/minimal.nix
    ../modules/common.nix
    ../modules/fonts.nix
    ../modules/dev.nix
    ../modules/multimedia.nix
    ../modules/work.nix
    ../modules/wayland.nix
    ../modules/home-services.nix
    ../modules/laptop.nix
  ];

  time.timeZone = "Europe/Berlin";

  home-manager.users.pimeys = {
    wayland.windowManager.sway = {
      config = { output = { "eDP-1" = { scale = "1.25"; }; }; };
    };
  };

  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" ];
      kernelModules = [ ];
    };

    kernelModules = [ "kvm-intel" ];

    kernelParams =
      [ "intel_pstate=passive" "i915.enable_fbc=1" "i915.enable_psr=2" ];
  };

  swapDevices = [ ];

  networking = {
    interfaces = {
      enp0s31f6.useDHCP = true;
      wlan0.useDHCP = true;
      wwp0s20f0u6i12.useDHCP = true;
    };

    hostId = "CC221B11";
    hostName = "muspus";
  };

  fileSystems."/" = {
    device = "zroot/root/nixos";
    fsType = "zfs";
  };

  fileSystems."/home" = {
    device = "zroot/home";
    fsType = "zfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/D95D-B8C7";
    fsType = "vfat";
  };
}
