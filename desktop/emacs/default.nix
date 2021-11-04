{ pkgs, lib, ... }:

{
  home-manager.users.pimeys = {
    home.file = { ".doom.d".source = ./doom.d; };
    programs.emacs = {
      enable = true;
      package = pkgs.emacsPgtkGcc;
      extraPackages = (epkgs: [ epkgs.vterm ]);
    };
  };
}
