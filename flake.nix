{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    doom-emacs.url = "github:vlaci/nix-doom-emacs";
  };

  outputs = inputs @ {
    self
    , nixpkgs
    , agenix
    , home-manager
    , doom-emacs
    , ...
  }: let
    inherit (nixpkgs) lib;
    system = "x86_64-linux";
    common-modules = [
      agenix.nixosModules.age
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
      modules = [ ./hosts/muspus.nix ] ++ common-modules;
    };
    nixosConfigurations.naunau = nixpkgs.lib.nixosSystem {
      system = system;
      modules = [ ./hosts/naunau.nix ] ++ common-modules;
    };
  };
}
