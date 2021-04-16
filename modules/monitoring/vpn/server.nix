# Server section of our Monitoring VPN config

#{ config, ip, privateKeyPath }:

let
  #cfg = config.services.wireguard.monitoring;
  cfg.port = 54321;

in {
  networking.firewall.allowedUDPPorts = [ cfg.port ];
  networking.wireguard.interfaces.monitoringvpn = {
    ips = [ "192.168.42.1/24" ];
    listenPort = cfg.port;
    privateKey = "cI2Rw37ihylMeDbfgH2PScJ9oFtqS1UmOkG6FfR2MWo=";
    peers = [
      { # node1
        allowedIPs = [ "192.168.42.11/32" ];
        publicKey = "tZ295cvD98ixt/VH4dwPKNgHf9MuhuzsossOWBOOoGU=";
      }
      { # node2
        allowedIPs = [ "192.168.42.12/32" ];
        publicKey = "zDxWTejJDXRRmUiMZPC7eVSCDdyFikN9VI6cqapQ6RY=";
      }
    ];
  };
}
