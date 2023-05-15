{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    comma.url = "github:nix-community/comma";
    hyprland.url = "github:hyprwm/Hyprland";

    curlossal.url = "github:jneem/curlossal";
    probe-rs-rules.url = "github:jneem/probe-rs-rules";
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
    };
}
