# See https://christine.website/blog/prometheus-grafana-loki-nixos-2020-11-20

{
  services.prometheus = {
    enable = true;
    port = 9001;
  };
}

