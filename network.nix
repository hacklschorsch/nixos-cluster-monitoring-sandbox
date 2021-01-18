#let
#  pkgs = import <nixpkgs> { };
#in
{
  test1 = {pkgs, config, ...}:
    {
      services.openssh.enable = true;
      # deployment.targetHost = "test1.example.net";

    };

  test2 = {pkgs, config, ...}:
    {
      imports = [ ./modules/prometheus-exporters-node.nix ];
      services.openssh.enable = true;
      # services.httpd.enable = true;
      # environment.systemPackages = [ pkgs.lynx ];
      # nixpkgs.localSystem.system = "x86_64-linux";
      # deployment.targetHost = "test2.example.net";
    };
}
