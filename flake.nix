{
  description = "Julius' system configuration.";

  # Where do we get our packages:
  inputs = {
    # Main NixOS monorepo. We follow the rolling release.
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-master.url = "nixpkgs/master";
    rust-overlay.url = "github:oxalica/rust-overlay";
    nixpkgs-wayland.url = "github:colemickens/nixpkgs-wayland";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    doom-emacs.url = "github:vlaci/nix-doom-emacs";
    emacs.url = "github:nix-community/emacs-overlay";
    nixos-hardware.url = "github:nixos/nixos-hardware";
  };

  outputs = inputs@{
    self
    , nixpkgs
    , home-manager
    , doom-emacs
    , ...
  }: let
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

    wayland = { pkgs, config, ... }: {
      config = {
        nix = {
          # add binary caches
          binaryCachePublicKeys = [
            "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
            "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
          ];
          binaryCaches = [
            "https://cache.nixos.org"
            "https://nixpkgs-wayland.cachix.org"
          ];
        };

        nixpkgs.overlays = [ inputs.nixpkgs-wayland.overlay ];
      };
    };

    emacs = { pkgs, config, ... }: {
      config = {
        nix = {
          # add binary caches
          binaryCachePublicKeys = [
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          ];
          binaryCaches = [
            "https://nix-community.cachix.org"
          ];
        };

        nixpkgs.overlays = [ inputs.emacs.overlay ];
      };
    };

    rust = { pkgs, config, ... }: {
      config.nixpkgs.overlays = [ inputs.rust-overlay.overlay ];
    };
  in {
    nixosConfigurations = {
      # ThinkPad T25 laptop runs this branch.
      muspus = nixpkgs.lib.nixosSystem {
        system = system;
        modules = [
          ./hosts/muspus.nix
          wayland
          emacs
          rust
        ] ++ home;
        specialArgs = {
          inherit inputs;
        };
      };

      # ThinkPad T25 laptop runs this branch.
      meowmeow = nixpkgs.lib.nixosSystem {
        system = system;
        modules = [
          ./hosts/meowmeow.nix
          wayland
          emacs
          rust
        ] ++ home;
        specialArgs = {
          inherit inputs;
        };
      };

      # The big workstation (AMD/NVIDIA) uses this.
      naunau = nixpkgs.lib.nixosSystem {
        system = system;
        modules = [
          ./hosts/naunau.nix
          emacs
          rust
        ] ++ home;
        specialArgs = {
          inherit inputs;
        };
      };
    };
  };
}
