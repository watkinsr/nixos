{
  description = "Julius' system configuration.";

  # Where do we get our packages:
  inputs = {
    # Main NixOS monorepo. We follow the rolling release.
    nixpkgs.url = "nixpkgs/nixos-unstable";

    # NixOS master. For quick patches, if needed
    nixpkgs-master.url = "nixpkgs/master";

    # Home manager handles whatever configuration is in my home directory.
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Doom emacs distribution, being better than VSCode in every way! And better
    # vim than vim.
    doom-emacs.url = "github:vlaci/nix-doom-emacs";

    # But, sometimes we also need vim. We compile the master to get the most up
    # to date version.
    neovim = {
      url = github:neovim/neovim?dir=contrib;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # For now in NixOS monorepo we don't have recent enough firefox. For now,
    # we'll use the nightly firefox.
    mozilla = {
      url = github:mozilla/nixpkgs-mozilla;
      flake = false;
    };
  };

  outputs = inputs@{ self, mozilla, nixpkgs, home-manager, doom-emacs, ... }: let
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
