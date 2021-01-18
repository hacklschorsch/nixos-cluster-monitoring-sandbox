{
  test1 = {pkgs, config, ...}:
    {
      services.openssh.enable = true;
      # deployment.targetHost = "test1.example.net";

    };

  test2 = {pkgs, config, ...}:
    {
      services.openssh.enable = true;
      # services.httpd.enable = true;
      # environment.systemPackages = [ pkgs.lynx ];
      # nixpkgs.localSystem.system = "x86_64-linux";
      # deployment.targetHost = "test2.example.net";

services.prometheus.exporters.node = {
    enable = true;
    enabledCollectors = [
      "logind"
      "systemd"
    ];
    disabledCollectors = [
      "textfile"
    ];
    # TODO: Open firewall to prometheus host
    # openFirewall = true;
    # firewallFilter = "-i br0 -p tcp -m tcp --dport 9100";
  };


    };
}
