{ lib, inputs, ... }:

(lib.pipe ./. [
  lib.findModules
  (lib.attrsets.mapAttrs (name: path:
    let
      system = lib.pipe (path + "/system") [ lib.readFile (lib.strings.splitString "\n") builtins.head ];
      pkgs-unstable = import inputs.nixpkgs-unstable {
        localSystem = { inherit system; };
      };
      
      curlossal-overlay = next: prev: {
        curlossal = inputs.curlossal.packages.${system}.default;
      };

      pkgs = import inputs.nixpkgs {
        localSystem = { inherit system; };
        config = {
          allowUnfree = true;
        };
        overlays = [ curlossal-overlay ];
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