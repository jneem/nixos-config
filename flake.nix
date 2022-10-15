{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-22.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
  };

  outputs =
    { self, nixpkgs, home-manager, nixos-hardware, ... }@inputs:
    let
      lib = import ./lib { inherit inputs nixpkgs; };
    in
    {
      nixosVersion = "22.05";
      nixosRoles = lib.findModules ./roles;
      nixosUsers = lib.findModules ./users;
      nixosModules = lib.findModules ./modules;
      nixosConfigurations = import ./configurations {
        inherit inputs lib;
      };

      #nixosConfigurations.zeus = nixpkgs.lib.nixosSystem {
        #inherit system;
        #modules = [
          #./configuration.nix
          #./boot/grub.nix
          #"${nixpkgs}/nixos/modules/services/hardware/sane_extra_backends/brscan4.nix"
          #./zeus/hardware-configuration.nix
          #./sway.nix
          #home-manager.nixosModules.home-manager
          #{ nix.nixPath = [ "nixpkgs=${nixpkgs}" ]; } # needed for nix-shell -p <sth> to work
        #];
        #specialArgs = { inherit inputs pkgs; };
      #};
    };
}
