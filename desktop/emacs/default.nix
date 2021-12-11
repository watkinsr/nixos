{ pkgs, lib, ... }:

let
  config = {
    config = ./emacs.el;
    package = pkgs.emacsPgtkGcc;
    alwaysEnsure = true;
    extraEmacsPackages = epkgs: [
      epkgs.use-package
      epkgs.prisma-mode
      epkgs.vterm
      pkgs.julius.emacsPackages.tree-sitter
      pkgs.julius.emacsPackages.tree-sitter-langs
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
