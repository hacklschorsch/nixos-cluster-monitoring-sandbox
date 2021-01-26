# Network definition file
#
# Scope: Network of virtual host to develop and test monitoring setup

# TODO:
#  - create beautiful dashboards
#  - Should we monitor the monitoring hosts as well? I think yes
#    - DRY
{
  # Monitoring infrastructure

  prometheus = {
    imports = [ ./modules/prometheus.nix ];
    networking.firewall.allowedTCPPorts = [ 9001 ];
    # deployment.targetHost = "prometheus.example.net";
  };

  grafana = {
    imports = [ ./modules/grafana.nix ];
    networking.firewall.allowedTCPPorts = [ 80 2342 ];
    # deployment.targetHost = "grafana.example.net";
  };

  loki = {
    imports = [ ./modules/loki.nix ];
    # TODO: What is the right place for this?
    networking.firewall.allowedTCPPorts = [ 3100 ];
    # deployment.targetHost = "loki.example.net";
  };


  # Monitored machines

  node1 = {
    imports = [
      ./modules/prometheus-exporters-node.nix
      ./modules/promtail.nix
    ];
    networking.firewall.allowedTCPPorts = [ 9100 ];
    services.openssh.enable = true;
    # deployment.targetHost = "node1.example.net";
  };
}

