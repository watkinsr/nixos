{ config, lib, pkgs, modulesPath, inputs, ... }:

{
  imports =
    [
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x230
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

    hostId = "CC221B11";
    hostName = "x230";
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
    { device = "/dev/disk/by-uuid/81257f1e-b18c-4a98-a6ae-052480dafee8";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/717A-B66C";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/275d12bb-bf34-4b06-80f8-525a0515e744"; }
    ];
}
