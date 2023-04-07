{ inputs, pkgs, pkgs-unstable, ... }:

{
  imports = [
    ./hardware-configuration.nix
    inputs.self.nixosModules.boot.extlinux
    inputs.self.nixosRoles.base
    inputs.self.nixosRoles.ssh-server
    inputs.self.nixosRoles.nas
    inputs.self.nixosRoles.prometheus-exporter
    inputs.self.nixosRoles.grafana
    inputs.self.nixosUsers.jneeman.cli
  ];

  networking.hostId = "a0136412";

  boot.kernelParams = [ "panic=1" "boot.panic_on_fail" ];
  systemd.enableEmergencyMode = false;
  systemd.services."serial-getty@ttyS0".enable = pkgs.lib.mkDefault false;
  systemd.services."serial-getty@hvc0".enable = false;
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@".enable = false;
}
