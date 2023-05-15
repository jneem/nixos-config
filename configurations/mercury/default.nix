{ inputs, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    inputs.self.nixosModules.boot.systemd
    inputs.self.nixosRoles.base
    inputs.self.nixosRoles.desktop
    inputs.self.nixosUsers.jneeman.hyprland
    (inputs.nixos-hardware + "/dell/xps/13-9310")
  ];
}
