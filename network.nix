{
  test1 = {pkgs, config, ...}: {
      imports = [ ./modules/prometheus.nix ];
      services.openssh.enable = true;
      # deployment.targetHost = "test1.example.net";
    };

  test2 = {pkgs, config, ...}: {
      imports = [ ./modules/grafana.nix ];
      services.openssh.enable = true;
      # deployment.targetHost = "test2.example.net";
    };


  test10 = {pkgs, config, ...}: {
      imports = [ ./modules/prometheus-exporters-node.nix ];
      services.openssh.enable = true;
      # deployment.targetHost = "test10.example.net";
    };
}
