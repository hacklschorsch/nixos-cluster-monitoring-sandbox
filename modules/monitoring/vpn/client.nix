# Server section of our Monitoring VPN config

#{ config, ip, privateKeyPath }:

let
  #cfg = config.services.wireguard.monitoring;
  cfg.server = "loki";
  cfg.port = 54321;
  ip = "192.168.42.11";

in {
  networking.wireguard.interfaces.monitoringvpn = {
    ips = [ "${ip}/24" ];
    privateKey = "oFCEeXlRI+iU3UOgNsAOUCaLZFTEKAq4OrVAvusZYGo=";
    peers = [
      {
        allowedIPs = [ "192.168.42.1/32" ];
        endpoint = cfg.server + ":" + toString cfg.port;
        publicKey = "0fS5azg7bBhCSUocI/r9pNkDMVpnlXmJfu9NV3YfEkU=";
      }
    ];
  };
}

