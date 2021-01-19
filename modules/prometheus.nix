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
        job_name = "chrysalis";
        static_configs = [{
          targets = [ "127.0.0.1:${toString nodeCfg.port}" ];
        }];
      }
    ];
  };
}

