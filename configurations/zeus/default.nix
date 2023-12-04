{ inputs, config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    inputs.self.nixosModules.boot.grub
    inputs.self.nixosModules.greeter
    inputs.self.nixosRoles.base
    inputs.self.nixosRoles.desktop
    inputs.self.nixosRoles.steam
    inputs.self.nixosRoles.ssh-server
    inputs.self.nixosRoles.prometheus-exporter
    inputs.self.nixosUsers.jneeman.hyprland
  ];

  config = {
    greeter.hyprland = {
      enable = true;
      user = config.home-manager.users.jneeman;
    };

    boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
    networking.firewall.allowedTCPPorts = [ 3000 ]; # for testing the temperature collector
  };
}
