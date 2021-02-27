{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
      ../modules/common.nix
      ../modules/wayland.nix
      ../modules/home-services.nix
      ../modules/laptop.nix
    ];

  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" ];
      kernelModules = [ ];
    };

    kernelModules = [
      "kvm-intel"
      "acpi-call"
    ];

    kernelParams = [
      "intel_pstate=passive"
      "i915.enable_fbc=1"
      "i915.enable_psr=2"
    ];

    extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];
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

  hardware = {
    cpu.intel.updateMicrocode = true;
    opengl.extraPackages = with pkgs; [
      vaapiIntel
      libvdpau-va-gl
      vaapiVdpau
    ];
  };

  fileSystems."/" =
    { device = "rpool/root/nixos";
      fsType = "zfs";
    };

  fileSystems."/home" =
    { device = "rpool/home";
      fsType = "zfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/6CB4-D8D9";
      fsType = "vfat";
    };
}
