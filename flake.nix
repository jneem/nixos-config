{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
    #nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-22.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    curlossal.url = "github:jneem/curlossal";
  };

  outputs =
    { self, nixpkgs, home-manager, nixos-hardware, ... }@inputs:
    let
      system = "x86_64-linux";
      overlay = self: super: {
        curlossal = inputs.curlossal.packages.${system}.default;
      };

      pkgs = import nixpkgs {
        localSystem = { inherit system; };
        config = {
          allowUnfree = true;
          firefox.enableGoogleTalkPlugin = true;
        };
        overlays = [ overlay ];
      };
    in
    {
    nixosConfigurations.mercury = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./configuration.nix
        "${nixpkgs}/nixos/modules/services/hardware/sane_extra_backends/brscan4.nix"
        ./hardware-configuration.nix
        ./sway.nix
        (home-manager + "/nixos")
        (nixos-hardware + "/dell/xps/13-9310")
        { nix.nixPath = ["nixpkgs=${nixpkgs}"]; }  # needed for nix-shell -p <sth> to work
      ];
      specialArgs = { inherit inputs pkgs; };
    };
  };
}