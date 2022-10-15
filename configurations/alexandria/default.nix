{ inputs, pkgs, pkgs-unstable, ... }:

{
  imports = [
    ./hardware-configuration.nix
    inputs.self.nixosModules.boot.extlinux
    inputs.self.nixosRoles.base
    inputs.self.nixosRoles.ssh-server
    inputs.self.nixosUsers.jneeman
  ];
}
