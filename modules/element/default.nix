{ pkgs, lib, ... }:

{
  home-manager.users.pimeys = {
    xdg.desktopEntries.element = {
      name = "Element";
      genericName = "Chat";
      exec =
        "element-desktop --use-tray-icon --enable-features=UseOzonePlatform --ozone-platform=wayland";
      terminal = false;
      categories = [ "Application" "Chat" ];
    };
  };

  environment.systemPackages = with pkgs; [ element-desktop ];
}
