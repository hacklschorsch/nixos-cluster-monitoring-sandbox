# Network definition file
#
# Scope: Network of virtual host to develop and test monitoring setup

# TODO:
#  - configure monitoring software to actually monitor stuff, not just sit there
#    - prometheus
#    - loki
#  - create beautiful dashboards
#  - Should we monitor the monitoring hosts as well? I think yes
#    - DRY

{
  # Monitoring infrastructure

  prometheus = {
    imports = [ ./modules/prometheus.nix ];
    services.openssh.enable = true;
    # deployment.targetHost = "prometheus.example.net";
  };

  grafana = {
    imports = [ ./modules/grafana.nix ];
    services.openssh.enable = true;
    # deployment.targetHost = "grafana.example.net";
  };

  loki = {
    imports = [ ./modules/loki.nix ];
    services.openssh.enable = true;
    # deployment.targetHost = "loki.example.net";
  };


  # Monitored machines

  node1 = {
    imports = [
      ./modules/prometheus-exporters-node.nix
      ./modules/promtail.nix
    ];
    services.openssh.enable = true;
    # deployment.targetHost = "node1.example.net";
  };
}

