{
  description = "Julius' system configuration.";

  # Where do we get our packages:
  inputs = {
    # Main NixOS monorepo. We follow the rolling release.
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-master.url = "nixpkgs/master";

    # Newest of the new rust.
    rust-overlay.url = "github:oxalica/rust-overlay";

    # Wayland latest of the latest.
    nixpkgs-wayland = {
      url = "github:colemickens/nixpkgs-wayland";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.master.follows = "nixpkgs-master";
    };

    # We take a working firefox from here.
    #nixpkgs-stable.url = "nixpkgs/nixos-20.09";

    # Home manager handles whatever configuration is in my home directory.
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Doom emacs distribution, being better than VSCode in every way! And better
    # vim than vim.
    doom-emacs.url = "github:vlaci/nix-doom-emacs";

    emacs.url = "github:nix-community/emacs-overlay";

    #mozilla = {
    #  url = github:mozilla/nixpkgs-mozilla;
    #  flake = false;
    #};
  };

  outputs = inputs@{ self, nixpkgs, home-manager, doom-emacs, ... }: let
    inherit (nixpkgs) lib;
    system = "x86_64-linux";

    # Home manager setup. We also import doom-emacs to be in the scope. See
    # `home.nix` for more.
    home = [
      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.pimeys = lib.mkMerge [
          {
            imports = [ doom-emacs.hmModule ];
          }
          ./home.nix
        ];
      }
    ];

    wayland = ({pkgs, config, ... }: {
      config = {
        nix = {
          # add binary caches
          binaryCachePublicKeys = [
            "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
            "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          ];
          binaryCaches = [
            "https://cache.nixos.org"
            "https://nixpkgs-wayland.cachix.org"
            "https://nix-community.cachix.org"
          ];
        };
      };

      nixpkgs.overlays = [ inputs.nixpkgs-wayland ];
    });
  in {
    nixosConfigurations = {
      # ThinkPad T25 laptop runs this branch.
      muspus = nixpkgs.lib.nixosSystem {
        system = system;
        modules = [ ./hosts/muspus.nix ] ++ home;
        specialArgs = {
          inherit inputs;
        };
      };

      # The big workstation (AMD/NVIDIA) uses this.
      naunau = nixpkgs.lib.nixosSystem {
        system = system;
        modules = [ ./hosts/naunau.nix ] ++ home;
        specialArgs = {
          inherit inputs;
        };
      };
    };
  };
}
