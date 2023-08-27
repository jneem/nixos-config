{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
    };

    devenv = {
      url = "github:cachix/devenv";
    };

    comma = {
      url = "github:nix-community/comma";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    curlossal = {
      url = "github:jneem/curlossal";
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    probe-rs-rules = {
      url = "github:jneem/probe-rs-rules";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
