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

  home-manager.users.pimeys = {
    programs.waybar.settings = {
      modules-right = [
        "custom/weather"
        "custom/dist"
        "custom/glucose"
      ];
      modules = {
        "custom/weather" = {
          exec = "~/.config/scripts/weather.sh";
          on-click = "xdg-open https://hass.local/lovelace/climate";
          format = "{} 🌡";
          interval = 60;
        };
        "custom/glucose" = {
          exec = "~/.config/scripts/glucose.sh";
          on-click = "xdg-open https://sokeri.nauk.io";
          format = "{} 🩸";
          interval = 30;
        };
        "custom/dist" = {
          exec = "node ~/.config/scripts/dist.js";
          format = "{} 💕";
          on-click = "xdg-open https://hass.local/lovelace/people";
          interval = 15;
        };
      };
    };
  };

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
