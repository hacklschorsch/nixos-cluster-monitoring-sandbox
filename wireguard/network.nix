# Network definition file
#
# Scope: Network of virtual hosts to develop and test monitoring setup

let

  server = "node1";
  clients = [ "node2" "node3" ];
  port = 54321;

in {

  "node1" = {
    networking.firewall.allowedUDPPorts = [ port ];
    networking.wireguard.interfaces.monitoringvpn = {
      ips = [ "192.168.42.1/24" ];
      privateKey = "cI2Rw37ihylMeDbfgH2PScJ9oFtqS1UmOkG6FfR2MWo=";
      listenPort = port;
      peers = [
        { # node2
          allowedIPs = [ "192.168.42.2/32" ];
          publicKey = "tZ295cvD98ixt/VH4dwPKNgHf9MuhuzsossOWBOOoGU=";
        }
        { # node3
          allowedIPs = [ "192.168.42.3/32" ];
          publicKey = "zDxWTejJDXRRmUiMZPC7eVSCDdyFikN9VI6cqapQ6RY=";
        }
      ];
    };
  };

  "node2" = {
    networking.wireguard.interfaces.monitoringvpn = {
      ips = [ "192.168.42.2/24" ];
      privateKey = "oFCEeXlRI+iU3UOgNsAOUCaLZFTEKAq4OrVAvusZYGo=";
      peers = [
        {
          allowedIPs = [ "192.168.42.0/24" ];
          endpoint = server + ":" + toString port;
          publicKey = "0fS5azg7bBhCSUocI/r9pNkDMVpnlXmJfu9NV3YfEkU=";
        }
      ];
    };
  };

  "node3" = {
    networking.wireguard.interfaces.monitoringvpn = {
      ips = [ "192.168.42.3/24" ];
      privateKey = "6EIThd2yJBNcUBHnpGxWgRhe2nRFJERb9tO8FH1e2nU=";
      peers = [
        {
          allowedIPs = [ "192.168.42.0/24" ];
          endpoint = server + ":" + toString port;
          publicKey = "0fS5azg7bBhCSUocI/r9pNkDMVpnlXmJfu9NV3YfEkU=";
        }
      ];
    };
  };
}

