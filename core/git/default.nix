{ lib, home-manager, pkgs, ... }: {
  home-manager.users.pimeys.programs.git = {
    enable = true;
    delta = {
      enable = true;
      options = {
        syntax-theme = "solarized-dark";
        minus-style = "#fdf6e3 #dc322f";
        plus-style = "#fdf6e3 #859900";
        side-by-side = false;
      };
    };
    userName = "Julius de Bruijn";
    userEmail = "julius+github@nauk.io";
    extraConfig = {
      pull.rebase = true;
      init.defaultBranch = "main";
      github.user = "pimeys";
    };
    aliases = {
      co = "checkout";
      br = "branch";
      st = "status";
      ci = "commit";
    };
  };
}
