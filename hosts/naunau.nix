# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
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
      ../modules/xorg.nix
      ../modules/home-services.nix
      ../modules/gaming.nix
    ];

  boot = {
    initrd = {
      availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
      kernelModules = [ ];
    };
    kernelModules = [ "kvm-amd" ];
    kernelParams = [ "nvidia-drm" "modeset=1" ];
    extraModulePackages = [ ];
  };

  networking = {
    hostId = "DD221B11";
    hostName = "naunau";
  };
  
  services.sshd.enable = true;

  services.xserver = {
    videoDrivers = [ "nvidia" ];

    config = ''
      Section "Screen"
          Identifier     "Screen0"
          Device         "Device0"
          Monitor        "Monitor0"
          DefaultDepth   24
          Option         "Stereo" "0"
          Option         "nvidiaXineramaInfoOrder" "DFP-5"
          Option         "metamodes" "nvidia-auto-select +0+0 {ForceCompositionPipeline=On, ForceFullCompositionPipeline=On}"
          Option         "SLI" "Off"
          Option         "MultiGPU" "Off"
          Option         "BaseMosaic" "off"
          SubSection     "Display"
          Depth          24
          EndSubSection
      EndSection
    '';
  };

  hardware = {
    cpu.amd.updateMicrocode = true;
    opengl.enable = true;
    nvidia = {
      modesetting.enable = true;
    };
  };

  nix.maxJobs = 32;
  powerManagement.cpuFreqGovernor = "performance";

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
