# See https://christine.website/blog/prometheus-grafana-loki-nixos-2020-11-20

{ config, ... }: {
  # grafana configuration
  services.grafana = {
    enable = true;
    domain = "grafana.pele"; # TODO: have own domain name
    port = 2342;
    addr = "127.0.0.1";
  };
  
  # nginx reverse proxy
  services.nginx.virtualHosts.${config.services.grafana.domain} = {
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.grafana.port}";
      proxyWebsockets = true;
    };
  };
}

