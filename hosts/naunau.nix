{ config, lib, pkgs, modulesPath, inputs, ... }:

{
  imports =
    [
      inputs.nixos-hardware.nixosModules.common-cpu-amd
      (modulesPath + "/installer/scan/not-detected.nix")
      ../modules/common.nix
      ../modules/virtualization.nix
      ../modules/fonts.nix
      ../modules/dev.nix
      ../modules/multimedia.nix
      ../modules/work.nix
      ../modules/home-services.nix
      ../modules/gaming.nix
      ../modules/wayland.nix
    ];

  boot = {
    initrd = {
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "ahci"
        "usb_storage"
        "usbhid"
        "sd_mod"
      ];
      kernelModules = [ ];
    };
    kernelModules = [ "kvm-amd" ];
    kernelParams = [ "amdgpu.freesync_video=1" ];
    extraModulePackages = with pkgs; [];
  };

  networking = {
    hostId = "DD221B11";
    hostName = "naunau";
  };
  
  services.sshd.enable = true;

  hardware = {
    cpu.amd.updateMicrocode = true;
  };

  nix.maxJobs = 32;
  powerManagement.cpuFreqGovernor = "performance";

  environment.systemPackages = with pkgs; [
    corectrl
  ];

  fileSystems."/" =
    { device = "zroot/root/nixos";
      fsType = "zfs";
    };

  fileSystems."/home" =
    { device = "zroot/home";
      fsType = "zfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/1D53-9739";
      fsType = "vfat";
    };

  fileSystems."/mnt/scratch" =
    { device = "/dev/disk/by-id/ata-HGST_HTS725050A7E630_TF755AWHG6DWHM";
      fsType = "btrfs";
      options = [ "subvol=_sata/scratch" "noatime"];
    };

  fileSystems."/mnt/steam" =
    { device = "/dev/disk/by-id/ata-HGST_HTS725050A7E630_TF755AWHG6DWHM";
      fsType = "btrfs";
      options = [ "subvol=_sata/steam" "noatime"];
    };

  swapDevices = [ ];
}
