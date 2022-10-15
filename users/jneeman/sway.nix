{ inputs, pkgs, config, ... }:

{
  imports = [ ./common.nix ];
  
  home-manager.users.jneeman = (import ./modules/home-sway.nix { inherit config inputs pkgs; });
}