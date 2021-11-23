{ pkgs, lib, ... }:

{
  home-manager.users.pimeys = {
    xdg.desktopEntries.slack = {
      name = "Slack Wayland";
      genericName = "Instant Messenger";
      exec = "slack --enable-features=UseOzonePlatform --ozone-platform=wayland";
      terminal = false;
      categories = [ "Application" "Chat" ];
    };
  };

  environment.systemPackages = with pkgs; [ slack ];
}

