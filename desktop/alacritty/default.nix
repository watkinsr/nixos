{ pkgs, home-manager, ... }: {
  home-manager.users.ryan.programs.alacritty = {
    enable = true;
    settings = {
      env = { TERM = "xterm-256color"; };
      scrolling = { history = 100000; };
      font = {
        normal = {
          family = "Inconsolata";
          style = "Regular";
        };
        bold = {
          family = "Inconsolata";
          style = "Bold";
        };
        italic = {
          family = "Inconsolata";
          style = "Italic";
        };
        bold_italic = {
          family = "Inconsolata";
          style = "Bold Italic";
        };
        size = 14.0;
      };
      background_opacity = 0.9;
      colors = import ./solarized_dark.nix { };
    };
  };
}
