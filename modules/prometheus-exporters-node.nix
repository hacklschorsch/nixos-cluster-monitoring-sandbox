# This is our common node exporter config for our monitoring setup.

# Thx https://nixos.org/manual/nixos/stable/#module-services-prometheus-exporters
{ config, ... }:

let

  cfg = config.services.prometheus.exporters.node;

in

{
  ## TODO: I would like to write:
  # cfg.enable = true;
  # but that fails with an error:
  # The option `cfg' defined in `...' does not exist.

  config.services.prometheus.exporters.node = {
    enable = true;
    enabledCollectors = [
      "logind"
      "systemd"
    ];
    disabledCollectors = [
      "textfile"
    ];
    # TODO: Open firewall only to prometheus host
    openFirewall = true;
    firewallFilter = "-i br0 -p tcp -m tcp --dport 9100";
  };
}

