{ pkgs, lib, ... }:

let
  config = {
    config = ./emacs.el;
    package = pkgs.emacsPgtkGcc;
    alwaysEnsure = true;
    extraEmacsPackages = epkgs: [
      epkgs.use-package
      pkgs.julius.emacsPackages.prisma-mode
    ];
  };
in {
  services.emacs = {
    enable = true;
    package = with pkgs; (pkgs.emacsWithPackagesFromUsePackage config);
  };
  home-manager.users.pimeys = {
    home.file = {
      ".emacs.d/init.el" = {
        source = ./init.el;
        recursive = true;
      };
    };
  };
}
