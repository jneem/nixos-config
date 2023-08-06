{ inputs, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    inputs.self.nixosModules.boot.grub
    inputs.self.nixosModules.hyprland-autologin
    inputs.self.nixosRoles.base
    inputs.self.nixosRoles.desktop
    inputs.self.nixosRoles.steam
    inputs.self.nixosRoles.ssh-server
    inputs.self.nixosRoles.prometheus-exporter
    inputs.self.nixosUsers.jneeman.hyprland
  ];
}
