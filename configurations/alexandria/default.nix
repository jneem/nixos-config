{ inputs, pkgs, ... }:
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

  config = {
    networking.hostId = "a0136412";

    boot.kernelParams = [ "panic=1" "boot.panic_on_fail" ];
    systemd.enableEmergencyMode = false;

    documentation.man.enable = false;
    documentation.info.enable = false;

    systemd.services."serial-getty@ttyS0".enable = pkgs.lib.mkDefault false;
    systemd.services."serial-getty@hvc0".enable = false;
    systemd.services."getty@tty1".enable = false;
    systemd.services."autovt@".enable = false;

    users.users.root.openssh.authorizedKeys.keys = [
      ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGpAveBRfqrg7a41+qdOxw5WT3CbEi7dwlgKObSM85YP'' 
    ];

    networking.firewall.allowedTCPPorts = [ 5432 3000 8086 ];

    users.users.temperatures = { isSystemUser = true; group = "temperatures"; };
    users.groups.temperatures = {};
    
    # TODO: figure out secrets management, and add some initial
    # config here.
    services.influxdb2 = {
      enable = true;
    };

    environment.systemPackages = [
      pkgs.influxdb2-cli
    ];
  };
}
