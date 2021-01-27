# Network definition file
#
# Scope: Network of virtual host to develop and test monitoring setup

# TODO:
#  - create beautiful dashboards
#  - Should we monitor the monitoring hosts as well? I think yes
#    - DRY
{
  # Monitoring infrastructure

  "prometheus" = {
    imports = [ ./modules/prometheus.nix ];
    # TODO: What is the right place for the firewall configs?
    # How to best also limit the hosts that can access the ports?
    networking.firewall.allowedTCPPorts = [ 9001 ];
    # deployment.targetHost = "prometheus.grid.private.storage";
  };

  "grafana" = {
    imports = [ ./modules/grafana.nix ];
    networking.firewall.allowedTCPPorts = [ 80 2342 ];
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

