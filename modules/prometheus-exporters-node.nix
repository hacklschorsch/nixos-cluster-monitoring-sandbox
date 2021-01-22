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
    port = 9100;
    # firewallFilter = "-p tcp -m tcp --dport ${toString port}"; # TODO: why does this not work?
    firewallFilter = "-p tcp -m tcp --dport 9100";
  };
}

