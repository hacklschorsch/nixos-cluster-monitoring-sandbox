# Prometheus common nginx exporter config
#
# Scope: Export nginx web server stats, polled by Prometheus server
# Usage: Import this to every server you want to include in the central
#        monitoring system
# See https://nixos.org/manual/nixos/stable/#module-services-prometheus-exporters

rec {
  config.networking.firewall.allowedTCPPorts = [ config.services.prometheus.exporters.nginx.port ];

  config.services.prometheus.exporters.nginx = {
    enable = true;
    openFirewall = true;
    port = 9113; # default is 9113
  };
}

