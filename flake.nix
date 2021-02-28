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
  };

  outputs = inputs: let
    inherit (inputs.nixpkgs) lib;
    system = "x86_64-linux";

    home = [
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.pimeys = lib.mkMerge [
          {
            imports = [ inputs.doom-emacs.hmModule ];
          }
          ./home.nix
        ];
      }
    ];
  in {
    nixosConfigurations.muspus = inputs.nixpkgs.lib.nixosSystem {
      system = system;
      modules = [ ./hosts/muspus.nix ] ++ home;
      specialArgs = { inherit inputs; };
    };
    nixosConfigurations.naunau = inputs.nixpkgs.lib.nixosSystem {
      system = system;
      modules = [ ./hosts/naunau.nix ] ++ home;
      specialArgs = { inherit inputs; };
    };
  };
}
