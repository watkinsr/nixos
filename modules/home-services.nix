{ config, lib, pkgs, ... }:

{
  services = {
    # Holy fuck this printer. Installation instructions for the future me:
    #
    # - Open CUPS admin: http://localhost:631/
    # - Printer type LPD/LPR
    # - Address: socket://10.0.0.17:9100 (or whatever IP you set in your future router)
    printing = {
      enable = true;
      drivers = with pkgs; [ brlaser ];
    };
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
