{ pkgs, lib, ... }:

let
  config = {
    config = ./emacs.el;
    package = pkgs.emacs;
    alwaysEnsure = true;
    extraEmacsPackages = epkgs: [
      epkgs.use-package
    ];
  };
in {
  services.emacs = {
    enable = true;
    package = with pkgs; (pkgs.emacsWithPackagesFromUsePackage config);
  };
  home-manager.users.ryan = {
    home.file = {
      ".emacs.d/init.el" = {
        source = ./init.el;
        recursive = true;
      };
    };
  };
}
