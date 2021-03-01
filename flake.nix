{
  description = "Julius' system configuration.";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    doom-emacs.url = "github:vlaci/nix-doom-emacs";
    neovim-nightly = {
      url = github:neovim/neovim?dir=contrib;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-mozilla = {
      url = github:mozilla/nixpkgs-mozilla;
      flake = false;
    };
  };

  outputs = inputs@{ self, nixpkgs-mozilla, nixpkgs, home-manager, doom-emacs, ... }: let
    inherit (nixpkgs) lib;
    system = "x86_64-linux";

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
  in {
    nixosConfigurations = {
      # ThinkPad T25
      muspus = nixpkgs.lib.nixosSystem {
        system = system;
        modules = [ ./hosts/muspus.nix ] ++ home;
        specialArgs = {
          inherit inputs;
          inherit nixpkgs-mozilla;
        };
      };

      # The big workstation
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
