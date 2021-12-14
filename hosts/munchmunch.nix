{ config, lib, pkgs, modulesPath, inputs, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ../core
    ../core/home-services.nix
    ../desktop
  ];

  time.timeZone = "Europe/Berlin";

  home-manager.users.pimeys = {
    wayland.windowManager.sway = {
      config = { output = { "*" = { scale = "1.5"; }; }; };
    };
  };

  services = {
    nginx = {
      enable = true;
      virtualHosts = {
        # ... existing hosts config etc. ...
        "munchmunch" = {
          serverAliases = [ "munchmunch" ];
          locations."/".extraConfig = ''
          proxy_pass http://localhost:${toString config.services.nix-serve.port};
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          '';
        };
      };
    };

    nix-serve = {
      enable = true;
      secretKeyFile = "/var/cache-priv-key.pem";
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
