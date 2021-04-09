# Prometheus server
#
# Scope: Pull data from our cluster machines into TSDB
# See https://christine.website/blog/prometheus-grafana-loki-nixos-2020-11-20

{ config, lib, ... }:
let

  exportersCfg = config.services.prometheus.exporters;
  cfg = config.services.private-storage.monitoring.prometheus;

in {
  options.services.private-storage.monitoring.prometheus = {
    nodeExporterTargets = lib.mkOption {
      type = with lib.types; listOf str;
      example = lib.literalExample "[ node1 node2 ]";
      description = "List of nodes (hostnames or IPs) to scrape.";
    };
    nginxExporterTargets = lib.mkOption {
      type = with lib.types; listOf str;
      example = lib.literalExample "[ node1 node2 ]";
      description = "List of nodes (hostnames or IPs) to scrape.";
    };
  };

  config = rec {
    networking.firewall.allowedTCPPorts = [ services.prometheus.port ];

    services.prometheus = {
      enable = true;
      port = 9090; # Option only in recent (20.09?) nixpkgs, 9090 default
      scrapeConfigs = [
        {
          job_name = "node-exporters";
          static_configs = [{
            targets = map (x: x + ":" + (toString exportersCfg.node.port)) cfg.nodeExporterTargets;
          }];
        }
        {
          job_name = "nginx-exporters";
          static_configs = [{
            targets = map (x: x + ":" + (toString exportersCfg.nginx.port)) cfg.nginxExporterTargets;
          }];
        }
      ];
    };
  };
}

