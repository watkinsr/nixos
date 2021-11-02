{ config, lib, pkgs, modulesPath, inputs, ... }:

{
  imports =
    [
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t14
      (modulesPath + "/installer/scan/not-detected.nix")
      ../modules/common.nix
      ../modules/fonts.nix
      ../modules/dev.nix
      ../modules/multimedia.nix
      ../modules/work.nix
      ../modules/wayland.nix
      ../modules/laptop.nix
    ];

  time.timeZone = "Europe/Berlin";

  services.sshd.enable = true;

  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "ehci_pci" "ata_piix" "usb_storage" "sd_mod" "sdhci_pci" ];
      kernelModules = [ ];
    };

    kernelModules = [
      "kvm-intel"
    ];

    kernelParams = [
      "intel_pstate=passive"
      "i915.enable_fbc=1"
      "i915.enable_psr=2"
    ];
  };

  networking = {
    interfaces = {
      enp0s25.useDHCP = true;
      wlan0.useDHCP = true;
    };

    hostId = "CC221B12";
    hostName = "t14";
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
    { device = "/dev/disk/by-uuid/58c6dfcb-1176-4084-b229-b5262c1ce74b";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/B0FA-1759";
      fsType = "vfat";
    };

  swapDevices = [ ];
}
