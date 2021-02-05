# Prometheus common node exporter config
#
# Scope: Export platform data like CPU, memory, disk space etc. to be
#        polled by Prometheus server
# Usage: Import this to every server you want to include in the central
#        monitoring system
# See https://nixos.org/manual/nixos/stable/#module-services-prometheus-exporters

{
  config.networking.firewall.allowedTCPPorts = [ 9100 ];

  config.services.prometheus.exporters.node = {
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

