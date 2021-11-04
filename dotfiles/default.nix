{ pkgs, ... }: rec {
  xdg = {
    configFile = {
      "pictures".source = ./pictures;
      "wofi/style.css".source = ./wofi/style.css;
      "wlogout/layout".source = ./wlogout/layout;
      "scripts/battery.sh".source = ./scripts/battery.sh;
      "scripts/weather.sh".source = ./scripts/weather.sh;
      "scripts/glucose.sh".source = ./scripts/glucose.sh;
      "scripts/cpu.pl".source = ./scripts/cpu.pl;
      "scripts/memory.sh".source = ./scripts/memory.sh;
      "scripts/temperature.sh".source = ./scripts/temperature.sh;
      "scripts/wifi.sh".source = ./scripts/wifi.sh;
      "scripts/dist.js".source = ./scripts/dist.js;
      "mc/selenized.ini".source = ./mc/selenized.ini;
      "kak-lsp/kak-lsp.toml".source = ./kak-lsp/kak-lsp.toml;
    };
  };
}
