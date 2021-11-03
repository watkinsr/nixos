{
  description = "Julius' system configuration.";

  # Where do we get our packages:
  inputs = {
    # Main NixOS monorepo. We follow the rolling release.
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-master.url = "nixpkgs/master";
    nixpkgs-wayland = {
      url = "github:nix-community/nixpkgs-wayland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-tom = {
      url = "github:tomhoule/nixpkgs/upgrade/kak-lsp";
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

  outputs = inputs@{ self, nixpkgs, nixpkgs-master, nixpkgs-tom, nur
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
      master = mkPkgs nixpkgs-master [ ];
      tom = mkPkgs nixpkgs-tom [ ];

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
            users.pimeys = lib.mkMerge [ ./home.nix ];
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
            inputs.rust-overlay.overlay
            inputs.emacs.overlay
            nur.overlay

            (self: super: {
              master = master;
              tom = tom;
            })
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
    in {
      nixosConfigurations = {
        # ThinkPad T25 laptop runs this branch.
        muspus = nixpkgs.lib.nixosSystem {
          system = system;
          modules = [
            ./hosts/muspus.nix
            common
            #wayland
          ] ++ home;
          specialArgs = {
            inherit inputs;
            inherit home-manager;
          };
        };

        # Prisma ThinkPad X1c
        purrpurr = nixpkgs.lib.nixosSystem {
          system = system;
          modules = [ ./hosts/purrpurr.nix common wayland ] ++ home;
          specialArgs = {
            inherit inputs;
            inherit home-manager;
          };
        };

        # ThinkPad X230 laptop runs this branch.
        meowmeow = nixpkgs.lib.nixosSystem {
          system = system;
          modules = [
            ./hosts/meowmeow.nix
            common
            #wayland
          ] ++ home;
          specialArgs = {
            inherit inputs;
            inherit home-manager;
          };
        };

        # The home workstation (AMD) uses this.
        naunau = nixpkgs.lib.nixosSystem {
          system = system;
          modules = [ ./hosts/naunau.nix common wayland ] ++ home;
          specialArgs = {
            inherit inputs;
            inherit home-manager;
          };
        };

        # The office workstation (AMD) uses this.
        munchmunch = nixpkgs.lib.nixosSystem {
          system = system;
          modules = [ ./hosts/munchmunch.nix common wayland ] ++ home;
          specialArgs = {
            inherit inputs;
            inherit home-manager;
          };
        };
      };
    };
}
