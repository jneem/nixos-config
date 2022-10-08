{ inputs, ... }:

let
  lib = inputs.nixpkgs.lib;
in

lib // rec {
  # Convert an attrset to a list of {name = "..."; value = "..."} pairs.
  attrsToList = lib.attrsets.mapAttrsToList lib.attrsets.nameValuePair;

  findModules = dir: lib.pipe dir [
    builtins.readDir
    attrsToList
    (lib.lists.foldr
      ({ name, value }: acc:
        let
          fullPath = dir + "/${name}";
          isNixModule = value == "regular" && lib.strings.hasSuffix ".nix" name && name != "default.nix";
          isDir = value == "directory";
          isDirModule = isDir && builtins.readDir fullPath ? "default.nix";
          module = lib.attrsets.nameValuePair (lib.strings.removeSuffix ".nix" name) (
            if isNixModule || isDirModule then fullPath
            else if isDir then findModules fullPath
            else { }
          );
        in
        if module.value == { } then acc
        else acc ++ [ module ]
      ) [ ])
    lib.attrsets.listToAttrs
  ];
}
