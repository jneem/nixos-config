{ inputs, pkgs, pkgs-unstable, ... }:

{
  imports = [
    ./hardware-configuration.nix
    inputs.self.nixosModules.boot.grub
    inputs.self.nixosRoles.desktop
    inputs.self.nixosUsers.jneeman
  ];
}
