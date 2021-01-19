# Network definition file
#
# Scope: Network of virtual host to develop and test monitoring setup

{
  test1 = {
      imports = [ ./modules/prometheus.nix ./modules/prometheus-exporters-node.nix ];
      services.openssh.enable = true;
      # deployment.targetHost = "test1.example.net";
    };

  test2 = {
      imports = [ ./modules/grafana.nix ./modules/prometheus-exporters-node.nix ];
      services.openssh.enable = true;
      # deployment.targetHost = "test2.example.net";
    };

  test3 = {
      imports = [ ./modules/loki.nix ./modules/prometheus-exporters-node.nix ];
      services.openssh.enable = true;
      # deployment.targetHost = "test3.example.net";
    };


  test10 = {
      imports = [ ./modules/prometheus-exporters-node.nix ./modules/promtail.nix ];
      services.openssh.enable = true;
      # deployment.targetHost = "test10.example.net";
    };
}

