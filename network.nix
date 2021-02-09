# Network definition file
#
# Scope: Network of virtual host to develop and test monitoring setup

# TODO:
#  - Parametrize the module files
#  - Create beautiful dashboards
#  - Should we monitor the monitoring hosts as well? I think yes
#    - DRY

# { config, lib, pkgs, ... }:
#
# with lib;
#
# let
#   # Some cool stuff here: https://github.com/mayflower/nixexprs/blob/master/modules/monitoring/default.nix
#   # hostName = name: machine:
#   #   machine.deployment.targetHost or
#   #     "${machine.networking.hostName}.${machine.containerDomains.${machine.hostBridge}}";
#   # hostNames = hosts: mapAttrsToList hostName hosts;
#
#   # allMachines = config.private-storage.machines; # or what it will be...
#   # allHosts = fold mergeAttrs allMachines (mapAttrsToList (_: machine: containersOfMachine machine) allMachines);
#   # allHostNames = hostNames allHosts;
#   # ...
#   # nginxExporterHostNames = hostNames (flip filterAttrs allHostsSameDC (_: m:
#   #   m.services.prometheus.exporters.nginx.enable
#   # ));
#   nodeExporterHostNames = [ "node1" ]; # TODO: make this automatic: list of all nodes importing prometheus-node-exporter
#   tahoeExporterHostNames = [ ];

let
   nodeExporterHostNames = [ "node1" "node2" ]; # TODO: make these automatic: list of all nodes importing prometheus-node-exporter, see above
   nginxExporterHostNames = [ "node2" ];

in {
  # Monitoring infrastructure

  "prometheus" = {
    imports = [ ./modules/prometheus.nix ];
    services.private-storage.monitoring.prometheus = {
      nodeExporterTargets = nodeExporterHostNames;
      nginxExporterTargets = nginxExporterHostNames;
    };
  };

  "grafana" = {
    # TODO: The Grafana node has no TLS support yet, add that to the reverse proxy NGINX before deployment
    imports = [ ./modules/grafana.nix ];
    services.private-storage.monitoring.grafana = {
      domain = "grafana.grid.private.storage";
    };
  };

  "loki" = {
    imports = [ ./modules/loki.nix ];
  };


  # Monitored machines

  "node1" = {
    imports = [
      ./modules/prometheus-exporters-node.nix
      ./modules/promtail.nix
    ];
  };

  "node2" = {
    imports = [
      ./modules/prometheus-exporters-nginx.nix
      ./modules/prometheus-exporters-node.nix
      ./modules/promtail.nix
    ];
    services.nginx.enable = true;
  };

  # "node3" = {
  #   imports = [
  #     ./modules/prometheus-exporters-tahoe.nix
  #     ./modules/prometheus-exporters-node.nix
  #     ./modules/promtail.nix
  #   ];
  #   services.tahoe.enable = true;
  # };
}

