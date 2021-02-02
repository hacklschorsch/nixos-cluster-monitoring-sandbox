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
    # TODO: What is the right place for the firewall configs?
    # How to best limit the hosts that can access the ports?
    # Not super simple according to this 2020/09 post
    # https://discourse.nixos.org/t/firewall-source-destination-ips/8919/2
    networking.firewall.allowedTCPPorts = [ 9090 ];
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
    networking.firewall.allowedTCPPorts = [ 80 443 ];
    # deployment.targetHost = "grafana.grid.private.storage";
  };

  "loki" = {
    imports = [ ./modules/loki.nix ];
    networking.firewall.allowedTCPPorts = [ 3100 ];
    # deployment.targetHost = "loki.grid.private.storage";
  };


  # Monitored machines

  "node1" = {
    imports = [
      ./modules/prometheus-exporters-node.nix
      ./modules/promtail.nix
    ];
    networking.firewall.allowedTCPPorts = [ 9100 ];
    services.openssh.enable = true;
    # deployment.targetHost = "node1.grid.private.storage";
  };
}

