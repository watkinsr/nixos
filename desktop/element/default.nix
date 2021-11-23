{ pkgs, lib, ... }:

{
  home-manager.users.pimeys = {
    xdg.desktopEntries.element = {
      name = "Element Wayland";
      genericName = "Chat";
      exec = "element-desktop --enable-features=UseOzonePlatform --ozone-platform=wayland";
      terminal = false;
      categories = [ "Application" "Chat" ];
    };
  };

  environment.systemPackages = with pkgs; [ element-desktop ];
}
