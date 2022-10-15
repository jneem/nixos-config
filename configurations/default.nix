{ lib, inputs, ... }:

(lib.pipe ./. [
  lib.findModules
  (lib.attrsets.mapAttrs (name: path:
    let
      system = lib.pipe (path + "/system") [ lib.readFile (lib.strings.splitString "\n") builtins.head ];
      pkgs-unstable = import inputs.nixpkgs-unstable {
        localSystem = { inherit system; };
      };
      
      pkgs = import inputs.nixpkgs {
        localSystem = { inherit system; };
        config = {
          allowUnfree = true;
        };
      };
    in
    lib.nixosSystem {
      inherit system;
      modules = [
        {
          system.stateVersion = inputs.self.nixosVersion;
          networking.hostName = lib.mkDefault name;
          nixpkgs = { inherit pkgs; };
        }
        (import path)
      ];
      specialArgs = { inherit inputs pkgs pkgs-unstable lib; };
    }
  ))
])
