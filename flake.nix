{
  description = "Julius' system configuration.";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    doom-emacs.url = "github:vlaci/nix-doom-emacs";
  };

  outputs = inputs @ {
    self
    , nixpkgs
    , home-manager
    , doom-emacs
    , ...
  }: let
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
    nixosConfigurations.muspus = nixpkgs.lib.nixosSystem {
      system = system;
      modules = [ ./hosts/muspus.nix ] ++ home;
    };
    nixosConfigurations.naunau = nixpkgs.lib.nixosSystem {
      system = system;
      modules = [ ./hosts/naunau.nix ] ++ home;
    };
  };
}
