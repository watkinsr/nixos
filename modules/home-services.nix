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

  networking = {
    extraHosts = ''
      10.0.0.2 hifiberry.local
      10.0.0.3 hass.local
      10.0.0.4 influxdb.local
      10.0.0.5 grafana.local
      10.0.0.6 unifi.local
      10.0.0.7 truenas.local
      10.0.0.8 transmission.local
      10.0.0.9 ipmi.local
      10.0.0.10 monolith.local
      10.0.0.11 artist.local
      10.0.0.13 tv.local
      10.0.0.15 postgres.local
      10.0.0.16 hue.local
      10.0.0.17 printer.local
      10.0.0.19 git.local
      10.0.0.20 shield.local
    '';
  };

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
