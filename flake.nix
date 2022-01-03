{
  description = "Julius' system configuration.";

  # Where do we get our packages:
  inputs = {
    # Main NixOS monorepo. We follow the rolling release.
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-wayland = {
      url = "github:nix-community/nixpkgs-wayland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacs.url = "github:nix-community/emacs-overlay";
    nixos-hardware.url = "github:nixos/nixos-hardware";
  };

  outputs = inputs@{ self, nixpkgs, nur
    , home-manager, ... }:
    let
      inherit (lib.my) mapModules mapModulesRec mapHosts;

      system = "x86_64-linux";

      mkPkgs = pkgs: extraOverlays:
        import pkgs {
          inherit system;
          config.allowUnfree = true; # forgive me Stallman senpai
          overlays = extraOverlays;
        };

      pkgs = mkPkgs nixpkgs [ ];

      lib = nixpkgs.lib.extend (self: super: {
        my = import ./lib {
          inherit pkgs inputs;
          lib = self;
        };
      });

      # Home manager setup. See `home.nix` for more.
      home = [
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.ryan = lib.mkMerge [ ./dotfiles ];
          };
        }
      ];

      common = { pkgs, config, ... }: {
        config = {
          nix = {
            # add binary caches
            binaryCachePublicKeys = [
              "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
              "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
            ];
            binaryCaches =
              [ "https://cache.nixos.org" "https://nix-community.cachix.org" ];
          };

          nixpkgs.overlays = [
            nur.overlay
            inputs.emacs.overlay
          ];
        };
      };

      wayland = { pkgs, config, ... }: {
        config = {
          nix = {
            # add binary caches
            binaryCachePublicKeys = [
              "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
            ];
            binaryCaches = [ "https://nixpkgs-wayland.cachix.org" ];
          };

          nixpkgs.overlays = [ inputs.nixpkgs-wayland.overlay ];
        };
      };

      defaultModules = [ common ] ++ home;
    in {
      nixosConfigurations = {
        # ThinkPad X230 laptop runs this branch.
        x230 = nixpkgs.lib.nixosSystem {
          system = system;
          modules = [ ./hosts/x230.nix ] ++ defaultModules;
          specialArgs = {
            inherit inputs;
            inherit home-manager;
          };
        };

        t14 = nixpkgs.lib.nixosSystem {
          system = system;
          modules = [ ./hosts/t14.nix ] ++ defaultModules;
          specialArgs = {
            inherit inputs;
            inherit home-manager;
          };
        };
      };
    };
}
