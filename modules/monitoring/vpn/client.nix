# Client section of our Monitoring VPN config

#{ config, ip, privateKeyPath }:

let
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


# just have all config static (no file systems etc)
# move cfg into global config (like config.privatestorage.monitoring.*)
# parametrize keys
#   - (https://wiki.archlinux.org/index.php/WireGuard
#   -  (wg genkey | tee peer_A.key | wg pubkey > peer_A.pub)
