{ inputs, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    inputs.self.nixosModules.boot.systemd
    inputs.self.nixosModules.gnome
    inputs.self.nixosRoles.base
    inputs.self.nixosRoles.desktop
    inputs.self.nixosRoles.ssh-server
    inputs.self.nixosUsers.jneeman.hyprland
    inputs.self.nixosUsers.bong
  ];
}
