{ pkgs, home-manager, ... }: {
  home-manager.users.ryan.programs.foot = {
    enable = true;
    server.enable = true;
    settings = {
      main = {
        term = "xterm-256color";
        font = "Inconsolata:size=10";
      };
      cursor = { color = "002b36 93a1a1"; };
      colors = {
        alpha = 1;
        #background = "103c48";
        background = "002B36";
        foreground = "adbcbc";

        regular0 = "184956";
        regular1 = "fa5750";
        regular2 = "75b938";
        regular3 = "dbb32d";
        regular4 = "4695f7";
        regular5 = "f275be";
        regular6 = "41c7b9";
        regular7 = "72898f";

        bright0 = "2d5b69";
        bright1 = "ff665c";
        bright2 = "84c747";
        bright3 = "ebc13d";
        bright4 = "58a3ff";
        bright5 = "ff84cd";
        bright6 = "53d6c7";
        bright7 = "cad8d9";
      };
    };
  };
}
