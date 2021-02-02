# Prometheus server
#
# Scope: Pull data from our cluster machines into TSDB
# See https://christine.website/blog/prometheus-grafana-loki-nixos-2020-11-20

{ config, lib, ... }:
let

  nodeCfg = config.services.prometheus.exporters.node;
  cfg = config.services.private-storage.monitoring.prometheus;

in {
  options.services.private-storage.monitoring.prometheus = {
    nodeExporterTargets = lib.mkOption {
      type = with lib.types; listOf str;
      example = lib.literalExample "[ node1 node2 ]";
      description = "List of nodes (hostnames or IPs) to scrape.";
    };
  };

  config = {
    services.prometheus = {
      enable = true;
      # port = 9090; # Option only in recent (20.09?) nixpkgs, 9090 default
      scrapeConfigs = [
        {
          job_name = "node-exporters";
          static_configs = [{
            targets = map (x: x + ":" + (toString nodeCfg.port)) cfg.nodeExporterTargets;
          }];
        }
      ];
    };
  };
}

