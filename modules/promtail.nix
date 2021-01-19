# Promtail systemd service
#
# Scope: Tail logs to central `Loki` logs aggregator
# See https://christine.website/blog/prometheus-grafana-loki-nixos-2020-11-20

{ pkgs, ... }: {
  systemd.services.promtail = {
    description = "Promtail service for Loki";
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      ExecStart = ''
        ${pkgs.grafana-loki}/bin/promtail --config.file ${./promtail.yaml}
      '';
    };
  };
}

