{ inputs, pkgs, config, ... }:

{
  imports = [ ./common.nix ];
  
  home-manager.users.jneeman = (import ./modules/home-hyprland.nix { inherit config inputs pkgs; });
}