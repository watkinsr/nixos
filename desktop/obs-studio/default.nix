{ pkgs, lib, ... }:

{
  home-manager.users.pimeys = {
    programs.obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
      ];
    };
  };
}
