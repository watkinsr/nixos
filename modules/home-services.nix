{ config, lib, pkgs, ... }:

{
  services = {
    # lpadmin -p Brother -E -v ipp://10.0.0.17/ipp -m everywhere
    printing = {
      enable = true;
      allowFrom = [ "localhost" "muspus" "naunau" ];
      drivers = with pkgs; [ brlaser ];
    };
  };

  hardware = {
    printers = {
      ensureDefaultPrinter = "Brother_Upstairs";
      ensurePrinters = [
        {
          description = "Brother MFC-L2710DW";
          deviceUri = "ipp://10.0.0.17/ipp";
          location = "Living room";
          name = "Brother_Upstairs";
          model = "everywhere";
          ppdOptions = {
            PageSize = "A4";
          };
        }
      ];
    };

    sane = {
      enable = true;
      brscan4 = {
        enable = true;
        netDevices = {
          home = { model = "MFC-L2710DW"; ip = "10.0.0.17"; };
        };
      };
    };
  };

  programs.system-config-printer.enable = true;

  environment.systemPackages = with pkgs; [
    simple-scan
  ];

  #
  # NAS mounts
  #
  fileSystems."/mnt/music" =
    { device = "10.0.0.7:/mnt/BOX/Music";
      fsType = "nfs";
    };

  fileSystems."/mnt/opus" =
    { device = "10.0.0.7:/mnt/BOX/Opus";
      fsType = "nfs";
    };

  fileSystems."/mnt/movies" =
    { device = "10.0.0.7:/mnt/BOX/Movies";
      fsType = "nfs";
    };

  fileSystems."/mnt/torrent" =
    { device = "10.0.0.7:/mnt/BOX/Bittorrent";
      fsType = "nfs";
    };
}
