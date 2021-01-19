# Prometheus common node exporter config
#
# Scope: Export platform data like CPU, memory, disk space etc. to be
#        polled by Prometheus server
# Usage: Import this to every server you want to include in the central
#        monitoring system
# See https://nixos.org/manual/nixos/stable/#module-services-prometheus-exporters

{
  config.services.prometheus.exporters.node = {
    enable = true;

    enabledCollectors = [
      "logind"
      "systemd"
    ];

    disabledCollectors = [
      "textfile"
    ];

    # TODO: Open firewall only to prometheus host
    openFirewall = true;
    firewallFilter = "-i br0 -p tcp -m tcp --dport 9100";
  };
}

