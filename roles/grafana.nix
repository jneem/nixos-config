{ config, pkgs, inputs, ... }:

{
  services.grafana = {
    enable = true;
    settings.server = {
      domain = "alexandria.lan";
      http_port = 2342;
      http_addr = "127.0.0.1";
    };
  };

  services.prometheus = {
    enable = true;
    port = 9001;

    scrapeConfigs = [
      {
        job_name = "zeus";
        static_configs = [{
          targets = [ "zeus.lan:9002" ];
        }];
      }
      {
        job_name = "alexandria";
        static_configs = [{
          targets = [ "alexandria.lan:9002" ];
        }];
      }
    ];
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
  services.nginx = {
    enable = true;
    virtualHosts.${config.services.grafana.settings.server.domain} = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.grafana.settings.server.http_port}";
        recommendedProxySettings = true;
        proxyWebsockets = true;
      };
    };
  };
}
