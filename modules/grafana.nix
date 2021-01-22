# Grafana Server
#
# Scope: Beautiful plots of time series data retrieved from Prometheus
# See https://christine.website/blog/prometheus-grafana-loki-nixos-2020-11-20

{ config, ... }: {
  # grafana configuration
  services.grafana = {
    enable = true;
    domain = "grafana.private.storage"; # TODO: what will our system be called?
    port = 2342;
    #addr = "127.0.0.1";
    addr = "0.0.0.0";
  };

  services.grafana.provision = {
    enable = true;
    # See https://grafana.com/docs/grafana/latest/administration/provisioning/#datasources
    datasources = [{
      name = "Prometheus";
      type = "prometheus";
      access = "proxy";
      url = "http://prometheus:9001/"; # TODO: use variables?
      isDefault = true;
    } {
      name = "Loki";
      type = "loki";
      access = "proxy";
      url = "http://loki:3100/"; # TODO: use variables?
    }];
    # See https://grafana.com/docs/grafana/latest/administration/provisioning/#dashboards
    # dashboards = [{
    # }];
  };
  
  # nginx reverse proxy
  services.nginx.virtualHosts.${config.services.grafana.domain} = {
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.grafana.port}";
      proxyWebsockets = true;
    };
  };
}

