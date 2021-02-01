# Grafana Server
#
# Scope: Beautiful plots of time series data retrieved from Prometheus
# See https://christine.website/blog/prometheus-grafana-loki-nixos-2020-11-20

{ config, lib, ... }: {
  options.services.private-storage.monitoring.grafana = {
    domain = lib.mkOption
    { type = lib.types.str;
      example = lib.literalExample "grafana.private.storage";
      description = "The FQDN of the Grafana host";
    };
    pwa = lib.mkOption
    { type = lib.types.str;
      example = lib.literalExample "passw0rd";
      description = "PW";
    };
  };

  config = {
    services.grafana = {
      enable = true;
      port = 2342;
      security.adminPassword = config.services.private-storage.monitoring.grafana.pwa;
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
  };
}

