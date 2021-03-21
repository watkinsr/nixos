[{
  height = 30;
  modules-left = [ "sway/workspaces" ];
  modules-center = [ "sway/window" ];
  modules-right = [
    "custom/weather"
    "custom/dist"
    "custom/glucose"
    "network"
    "cpu"
    "memory"
    "temperature"
    "battery"
    "battery#bat2"
    "clock"
    "tray"
  ];

  modules = {
    "sway/workspaces" = {
      disable-scroll = false;
      all-outputs = true;
      format = "{name}: {icon}";
      format-icons = {
        "1" = "🍑";
        "2" = "🍌";
        "3" = "🍒";
        "4" = "🍓";
        "5" = "🍆";
        "6" = "🍄";
        "7" = "🍀";
        "8" = "🍇";
        "9" = "🌵";
        "10" = "🌟";
        "urgent" = "";
        "focused" = "";
        "default" = "";
      };
    };
    "tray" = {
      spacing = 10;
    };
    "clock" = {
      tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
      format-alt = "{:%Y-%m-%d}";
    };
    "cpu" = {
      format = "{usage}% ";
      tooltip = false;
    };
    "memory" = {
      format = "{}% ";
    };
    "temperature" = {
        critical-threshold = 80;
        format = "{temperatureC}°C {icon}";
        format-icons = ["" "" ""];
    };
    "battery" = {
      states = {
        good = 95;
        warning = 30;
        critical = 15;
      };
      format = "{time} {icon}";
      format-alt = "{capacity}% {icon}";
      format-charging = "{capacity}% ";
      format-plugged = "{capacity}% ";
      format-icons = ["" "" "" "" ""];
    };
    "battery#bat2" = {
      bat = "BAT2";
    };
    "network" = {
      format-wifi = "{essid} ({signalStrength}%) ";
      format-ethernet = "{ifname}: {ipaddr}/{cidr} ";
      format-linked = "{ifname} (No IP) ";
      format-disconnected = "Disconnected ⚠";
      format-alt = "{ifname}: {ipaddr}/{cidr}";
    };
    "custom/weather" = {
      exec = "~/.config/scripts/weather.sh";
      format = "{} 🌡";
      interval = 60;
    };
    "custom/glucose" = {
      exec = "~/.config/scripts/glucose.sh";
      format = "{} 🩸";
      interval = 30;
    };
    "custom/dist" = {
      exec = "node ~/.config/scripts/dist.js";
      format = "{} 💕";
      on-click = "xdg-open https://hass.local/lovelace/people";
      interval = 15;
    };
  };
}]
