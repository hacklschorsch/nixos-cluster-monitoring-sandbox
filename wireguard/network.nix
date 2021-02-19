# Network definition file
#
# Scope: Network of virtual hosts to develop and test monitoring setup

let

  server = "server";
  clients = [ "node1" "node2" ];
  port = 54321;

in {

  "server" = {
    networking.firewall.allowedUDPPorts = [ port ];
    networking.wireguard.interfaces.monitoringvpn = {
      ips = [ "192.168.42.1/24" ];
      privateKey = "cI2Rw37ihylMeDbfgH2PScJ9oFtqS1UmOkG6FfR2MWo=";
      listenPort = port;
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
  };

  "node1" = {
    networking.wireguard.interfaces.monitoringvpn = {
      ips = [ "192.168.42.11/24" ];
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

  "node2" = {
    networking.wireguard.interfaces.monitoringvpn = {
      ips = [ "192.168.42.12/24" ];
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

