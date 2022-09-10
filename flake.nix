{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-22.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    #curlossal.url = "github:jneem/curlossal";
  };

  outputs =
    { self, home-manager, nixos-hardware, ... }@inputs:
    let
      #nixpkgs = inputs.nixpkgs-unstable;
      nixpkgs = inputs.nixpkgs;
      system = "x86_64-linux";
      unstable = import inputs.nixpkgs-unstable {
        localSystem = { inherit system; };
      };
      overlay = self: super: {
        helix = unstable.helix;
        #curlossal = inputs.curlossal.packages.${system}.default;
      };

      pkgs = import inputs.nixpkgs {
        localSystem = { inherit system; };
        config = {
          allowUnfree = true;
          firefox.enableGoogleTalkPlugin = true;
        };
        overlays = [ overlay ];
      };
    in
    {
    nixosConfigurations.zeus = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./configuration.nix
        "${nixpkgs}/nixos/modules/services/hardware/sane_extra_backends/brscan4.nix"
        ./hardware-configuration.nix
        ./sway.nix
        #(home-manager + "/nixos")
        home-manager.nixosModules.home-manager
        { nix.nixPath = ["nixpkgs=${nixpkgs}"]; }  # needed for nix-shell -p <sth> to work
      ];
      specialArgs = { inherit inputs pkgs; };
    };
  };
}
