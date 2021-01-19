# Network definition file
#
# Scope: Network of virtual host to develop and test monitoring setup

# TODO:
#  - DRY
#  - configure monitoring software to actually monitor stuff, not just sit there
#    - prometheus
#    - loki
#  - create beautiful dashboards

{
  prometheus = {
      imports = [
        ./modules/prometheus.nix
        ./modules/prometheus-exporters-node.nix
        ./modules/promtail.nix
      ];
      services.openssh.enable = true;
      # deployment.targetHost = "prometheus.example.net";
    };

  grafana = {
      imports = [
        ./modules/grafana.nix
        ./modules/prometheus-exporters-node.nix
        ./modules/promtail.nix
      ];
      services.openssh.enable = true;
      # deployment.targetHost = "grafana.example.net";
    };

  loki = {
      imports = [
        ./modules/loki.nix
        ./modules/prometheus-exporters-node.nix
        ./modules/promtail.nix
      ];
      services.openssh.enable = true;
      # deployment.targetHost = "loki.example.net";
    };


  node1 = {
      imports = [
        ./modules/prometheus-exporters-node.nix
        ./modules/promtail.nix
      ];
      services.openssh.enable = true;
      # deployment.targetHost = "node1.example.net";
    };
}

