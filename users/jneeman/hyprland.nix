{ inputs, pkgs, config, ... }:

{
  imports = [ ./common.nix ];
  
  home-manager.users.jneeman = (import ./modules/home-hyprland.nix { inherit config inputs pkgs; });

  # See https://github.com/NixOS/nixpkgs/issues/158025#issuecomment-1484137464
  security.pam.services.swaylock = {};
}