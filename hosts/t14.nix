{ config, lib, pkgs, modulesPath, inputs, ... }:

{
  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t14
    (modulesPath + "/installer/scan/not-detected.nix")
    ../core
    ../core/home-services.nix
    ../desktop/laptop.nix
    ../desktop
  ];

  time.timeZone = "Europe/London";

  services.sshd.enable = true;
  services.redis.enable = true;
  services.postgresql = {
    enable = true;
    enableTCPIP = true;
    authentication = pkgs.lib.mkOverride 10 ''
      local all all trust
      host all all ::1/128 trust
      host all all 127.0.0.1/32 trust
    '';
    initialScript = pkgs.writeText "backend-initScript" ''
      CREATE ROLE falcon WITH LOGIN PASSWORD 'falcon' CREATEDB;
      CREATE DATABASE falcon;
      GRANT ALL PRIVILEGES ON DATABASE falcon TO falcon;
    '';
  };

  boot = {
    initrd = {
      availableKernelModules =
        [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
      kernelModules = [ ];
    };

    kernelModules = [ "kvm-intel" ];

    kernelParams =
      [ "intel_pstate=passive" "i915.enable_fbc=1" "i915.enable_psr=2" ];
  };

  networking = {
    interfaces = {
      enp0s31f6.useDHCP = true;
      wlan0.useDHCP = true;
    };

    hostId = "CC221B12";
    hostName = "t14";
  };

  hardware = {
    cpu.intel.updateMicrocode = true;
    opengl.extraPackages = with pkgs; [ vaapiIntel libvdpau-va-gl vaapiVdpau ];
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/58c6dfcb-1176-4084-b229-b5262c1ce74b";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/B0FA-1759";
    fsType = "vfat";
  };

  swapDevices = [ ];
}
