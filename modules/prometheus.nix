# Prometheus server
#
# Scope: Pull data from our cluster machines into TSDB
# See https://christine.website/blog/prometheus-grafana-loki-nixos-2020-11-20

{ config, ... }:
let

  nodeCfg = config.services.prometheus.exporters.node;

in {
  services.prometheus = {
    enable = true;
    port = 9001;
    scrapeConfigs = [
      {
        job_name = "node1";
        static_configs = [{
          targets = [ "node1:${toString nodeCfg.port}" ];
        }];
      }
    ];
  };
}

