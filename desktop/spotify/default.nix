{ pkgs, lib, ... }:

{
  home-manager.users.ryan = {
    xdg.desktopEntries.spotify = {
      name = "Spotify";
      genericName = "Music Player";
      exec = "spotify";
      terminal = false;
      categories = [ "Application" "Music" ];
    };
  };

  environment.systemPackages = with pkgs; [ spotify ];
}
