{ config, lib, pkgs, modulesPath, inputs, ... }:

{
  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t470s
    (modulesPath + "/installer/scan/not-detected.nix")
    ../modules/minimal.nix
    ../modules/laptop.nix
    ../modules/desktop.nix
  ];

  time.timeZone = "Europe/Berlin";

  home-manager.users.pimeys = {
    wayland.windowManager.sway = {
      config = { output = { "*" = { scale = "1.5"; }; }; };
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

  hardware.video.hidpi.enable = lib.mkDefault true;

  fileSystems."/" = {
    device = "zroot/root/nixos";
    fsType = "zfs";
  };

  fileSystems."/home" = {
    device = "zroot/home";
    fsType = "zfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/DED2-1948";
    fsType = "vfat";
  };

  swapDevices = [ ];

  networking = {
    interfaces = {
      enp0s31f6.useDHCP = true;
      wlan0.useDHCP = true;
    };

    hostId = "CC221B11";
    hostName = "purrpurr";
  };
}
