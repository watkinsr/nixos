{ config, lib, pkgs, ... }:

{
  services = {
    tlp = { enable = true; };
  };

  powerManagement = {
    enable = true;
  };

  systemd.services.lock-before-sleeping = {
    restartIfChanged = false;
    unitConfig = {
      Description = "Helper service to bind locker to sleep.target";
    };
    serviceConfig = {
      ExecStart = "${pkgs.swaylock}/bin/swaylock -i /home/pimeys/Pictures/Ve0XkQ4.jpg";
      Type = "simple";
      User = "pimeys";
    };
    before = [
      "pre-sleep.service"
    ];
    wantedBy= [
      "pre-sleep.service"
    ];
    environment = {
      XDG_RUNTIME_DIR = "/run/user/1000";
    };
  };
}
