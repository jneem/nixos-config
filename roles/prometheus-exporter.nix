{ config, pkgs, inputs, ... }:

{
  services.prometheus = {
    exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
        openFirewall = true;
        port = 9002;
      };
    };
  };
}
