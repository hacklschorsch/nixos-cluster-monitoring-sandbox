# This is our common node exporter config for our monitoring setup.

# Thx https://nixos.org/manual/nixos/stable/#module-services-prometheus-exporters
{ config, pkgs, ... }:

{
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
}

