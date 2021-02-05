# Network definition file
#
# Scope: Network of virtual host to develop and test monitoring setup

# TODO:
#  - Parametrize the module files
#  - Create beautiful dashboards
#  - Should we monitor the monitoring hosts as well? I think yes
#    - DRY
{
  # Monitoring infrastructure

  "prometheus" = {
    imports = [ ./modules/prometheus.nix ];
    services.private-storage.monitoring.prometheus = {
      nodeExporterTargets = [ "node1" ]; # TODO: make this automatic: list of all nodes importing prometheus-node-exporter
    };
    # deployment.targetHost = "prometheus.grid.private.storage";
  };

  "grafana" = {
    # TODO: Grafana has no TLS support yet, add that to the reverse proxy NGINX
    imports = [ ./modules/grafana.nix ];
    services.private-storage.monitoring.grafana = {
      domain = "grafana.grid.private.storage";
    };
    # deployment.targetHost = "grafana.grid.private.storage";
  };

  "loki" = {
    imports = [ ./modules/loki.nix ];
    # deployment.targetHost = "loki.grid.private.storage";
  };


  # Monitored machines

  "node1" = {
    imports = [
      ./modules/prometheus-exporters-node.nix
      ./modules/promtail.nix
    ];
    services.openssh.enable = true;
    # deployment.targetHost = "node1.grid.private.storage";
  };
}

