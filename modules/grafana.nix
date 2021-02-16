# Grafana Server
#
# Scope: Beautiful plots of time series data retrieved from Prometheus
# See https://christine.website/blog/prometheus-grafana-loki-nixos-2020-11-20

{ config, lib, ... }:

let
  cfg = config.services.private-storage.monitoring.grafana;

in {
  options.services.private-storage.monitoring.grafana = {
    domain = lib.mkOption
    { type = lib.types.str;
      example = lib.literalExample "grafana.grid.private.storage";
      description = "The FQDN of the Grafana host";
    };
    prometheusUrl = lib.mkOption
    { type = lib.types.str;
      example = lib.literalExample "http://prometheus:9090/";
      default = "http://prometheus:9090/";
      description = "The URL of the Prometheus host to access";
    };
    lokiUrl = lib.mkOption
    { type = lib.types.str;
      example = lib.literalExample "http://loki:3100/";
      default = "http://loki:3100/";
      description = "The URL of the Loki host to access";
    };
  };

  config = {
    networking.firewall.allowedTCPPorts = [ 80 443 ];

    services.grafana = {
      enable = true;
      domain = cfg.domain;
      port = 2342;
      addr = "127.0.0.1";

      # All three are required to forego the user/pass prompt:
      auth.anonymous.enable = true;
      auth.anonymous.org_role = "Admin";
      auth.anonymous.org_name = "Main Org.";
    };

    services.grafana.provision = {
      enable = true;
      # See https://grafana.com/docs/grafana/latest/administration/provisioning/#datasources
      datasources = [{
        name = "Prometheus";
        type = "prometheus";
        access = "proxy";
        url = cfg.prometheusUrl;
        isDefault = true;
      } {
        name = "Loki";
        type = "loki";
        access = "proxy";
        url = cfg.lokiUrl;
      }];
      # See https://grafana.com/docs/grafana/latest/administration/provisioning/#dashboards
      dashboards = [{
        name = "provisioned";
        options.path = ./grafana-monitoring;
      }];
    };

    # nginx reverse proxy
    services.nginx.enable = true;
    services.nginx.virtualHosts.${config.services.grafana.domain} = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.grafana.port}";
        proxyWebsockets = true;
      };
    };
  };
}

