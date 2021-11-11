{ pkgs, ... }: rec {
  xdg = {
    configFile = {
      "pictures".source = ./pictures;
      "wofi/style.css".source = ./wofi/style.css;
      "wlogout/layout".source = ./wlogout/layout;
      "mc/selenized.ini".source = ./mc/selenized.ini;
    };
  };
}
