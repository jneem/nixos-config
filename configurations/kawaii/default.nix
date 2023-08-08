{ inputs, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    inputs.self.nixosModules.boot.systemd
    inputs.self.nixosModules.greeter
    inputs.self.nixosRoles.base
    inputs.self.nixosRoles.desktop
    inputs.self.nixosRoles.ssh-server
    inputs.self.nixosUsers.jneeman.hyprland
    inputs.self.nixosUsers.bong
  ];

  config = {
    greeter.gdm.enable = true;
  };
}
