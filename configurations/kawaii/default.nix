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

    users.users.root.openssh.authorizedKeys.keys = [
      ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGpAveBRfqrg7a41+qdOxw5WT3CbEi7dwlgKObSM85YP'' 
    ];
  };
}
