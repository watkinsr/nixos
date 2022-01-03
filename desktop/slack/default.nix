{ pkgs, lib, ... }:

{
  home-manager.users.ryan = {
    xdg.desktopEntries.slack = {
      name = "Slack";
      genericName = "Instant Messenger";
      exec = "slack";
      terminal = false;
      categories = [ "Application" "Chat" ];
    };
  };

  environment.systemPackages = with pkgs; [ slack ];
}

