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
    , nixpkgs-master
    , home-manager
    , doom-emacs
    , ...
  }: let
    inherit (lib.my) mapModules mapModulesRec mapHosts;

    system = "x86_64-linux";

    mkPkgs = pkgs: extraOverlays: import pkgs {
      inherit system;
      config.allowUnfree = true;  # forgive me Stallman senpai
      overlays = extraOverlays;
    };
    pkgs = mkPkgs nixpkgs [];
    master = mkPkgs nixpkgs-master [];

    lib = nixpkgs.lib.extend
      (self: super: { my = import ./lib { inherit pkgs inputs; lib = self; }; });

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

    common = { pkgs, config, ... }: {
      config = {
        nix = {
          # add binary caches
          binaryCachePublicKeys = [
            "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          ];
          binaryCaches = [
            "https://cache.nixos.org"
            "https://nix-community.cachix.org"
          ];
        };

        nixpkgs.overlays = [
          inputs.rust-overlay.overlay
          inputs.emacs.overlay

          (self: super: {
            master = master;
            my = self.packages."${system}";
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
          binaryCaches = [
            "https://nixpkgs-wayland.cachix.org"
          ];
        };

        nixpkgs.overlays = [
          inputs.nixpkgs-wayland.overlay
        ];
      };
    };
  in {
    packages."${system}" =
      mapModules ./packages (p: pkgs.callPackage p {});

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
        modules = [
          ./hosts/purrpurr.nix
          common
          #wayland
        ] ++ home;
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
        modules = [
          ./hosts/naunau.nix
          common
        ] ++ home;
        specialArgs = {
          inherit inputs;
          inherit home-manager;
        };
      };

      # The office workstation (AMD) uses this.
      munchmunch = nixpkgs.lib.nixosSystem {
        system = system;
        modules = [
          ./hosts/munchmunch.nix
          common
        ] ++ home;
        specialArgs = {
          inherit inputs;
          inherit home-manager;
        };
      };
    };
  };
}
