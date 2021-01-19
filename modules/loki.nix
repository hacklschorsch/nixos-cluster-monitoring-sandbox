# Loki Server
#
# Scope: Log aggregator
# See https://christine.website/blog/prometheus-grafana-loki-nixos-2020-11-20

{
  services.loki = {
    enable = true;
    configFile = ./loki.yaml;
  };
}

