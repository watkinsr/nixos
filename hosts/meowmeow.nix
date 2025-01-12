{ config, lib, pkgs, modulesPath, inputs, ... }:

{
  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x230
    (modulesPath + "/installer/scan/not-detected.nix")
    ../core
    ../core/home-services.nix
    ../desktop/laptop.nix
    ../desktop
  ];

  time.timeZone = "Europe/Berlin";

  boot = {
    initrd = {
      availableKernelModules =
        [ "xhci_pci" "ehci_pci" "ata_piix" "usb_storage" "sd_mod" "sdhci_pci" ];
      kernelModules = [ ];
    };

    kernelModules = [ "kvm-intel" ];

    kernelParams =
      [ "intel_pstate=passive" "i915.enable_fbc=1" "i915.enable_psr=2" ];
  };

  swapDevices = [ ];

  networking = {
    interfaces = {
      enp0s25.useDHCP = true;
      wlan0.useDHCP = true;
      wwp0s20u4i6.useDHCP = true;
    };

    hostId = "CC221B11";
    hostName = "meowmeow";
  };

  hardware = {
    cpu.intel.updateMicrocode = true;
    opengl.extraPackages = with pkgs; [ vaapiIntel libvdpau-va-gl vaapiVdpau ];
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
    device = "/dev/disk/by-uuid/3C11-720D";
    fsType = "vfat";
  };
}
