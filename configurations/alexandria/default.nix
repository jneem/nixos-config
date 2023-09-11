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

    services.postgresql = {
      enable = true;
      enableTCPIP = true;
      authentication = ''
      host all all 192.168.86.0/24 md5
      '';
      ensureUsers = [
        {
          name = "grafanareader";
          ensureClauses = {
            login = true;
          };
          # How to add permission to the table temperatures within the database temperatures?
          ensurePermissions = {
            "DATABASE temperatures" = "CONNECT";
          };
        }
      ];
      initialScript = pkgs.writeText "initScript" ''
        CREATE ROLE temperatures WITH LOGIN PASSWORD 'password';
        CREATE DATABASE temperatures;
        GRANT ALL PRIVILEGES ON DATABASE temperatures TO temperatures;
      '';
    };
    networking.firewall.allowedTCPPorts = [ 5432 ];
  };
}
