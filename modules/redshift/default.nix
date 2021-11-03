{ lib, home-manager, pkgs, ... }: {
  home-manager.users.pimeys.services.redshift = {
    enable = true;
    package = pkgs.redshift-wlr;
    latitude = "52.4";
    longitude = "13.4";
    settings = {
      redshift = {
        brightness-day = "1";
        brightness-night = "0.75";
      };
    };
    tray = true;
  };
}
