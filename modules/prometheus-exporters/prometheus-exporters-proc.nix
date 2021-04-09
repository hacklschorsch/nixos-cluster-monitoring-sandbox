# Prometheus common proc exporter config
#
# Scope: Export data like memory or cpu usage per process "group"
#
# Usage: Import this to on every machine with arguments to match process names
#
# See https://github.com/ncabatoff/process-exporter and
#     https://grafana.com/grafana/dashboards/249

{
  config.networking.firewall.allowedTCPPorts = [ 9100 ];

  config.services.prometheus.exporters.proc = {
    enable = true;

    enabledCollectors = [
      "logind"
      "systemd"
    ];

    disabledCollectors = [
      "textfile"
    ];

    port = 9100;
  };
}


