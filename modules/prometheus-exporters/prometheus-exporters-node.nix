# Prometheus common node exporter config
#
# Scope: Export platform data like CPU, memory, disk space etc. to be
#        polled by Prometheus server
# Usage: Import this to every server you want to include in the central
#        monitoring system
# See https://nixos.org/manual/nixos/stable/#module-services-prometheus-exporters

{ config, lib, pkgs, ... }:

with lib;

let
  mountsFileSystemType = fsType: {} != filterAttrs (n: v: v.fsType == fsType) config.fileSystems;

in {
  config.networking.firewall.allowedTCPPorts = [ 9100 ];

  config.services.prometheus.exporters.node = {
    enable = true;
    openFirewall = true;
    port = 9100;
    extraFlags = [ "--collector.disable-defaults" ];
    # Thanks https://github.com/mayflower/nixexprs/blob/master/modules/monitoring/default.nix
    enabledCollectors = [
      "arp"
      "bcache"
      "conntrack"
      "filefd"
      "logind"
      "netclass"
      "netdev"
      "netstat"
      "rapl"
      "sockstat"
      "softnet"
      "stat"
      "systemd"
      # "textfile"
      # "textfile.directory /run/prometheus-node-exporter"
      "thermal_zone"
      "time"
      "udp_queues"
      "uname"
      "vmstat"
    ] ++ optionals (!config.boot.isContainer) [
      "cpu"
      "cpufreq"
      "diskstats"
      "edac"
      "entropy"
      "filesystem"
      "hwmon"
      "interrupts"
      "ksmd"
      "loadavg"
      "meminfo"
      "pressure"
      "timex"
    ] ++ (
      optionals (config.services.nfs.server.enable) [ "nfsd" ]
    ) ++ (
      optionals ("" != config.boot.initrd.mdadmConf) [ "mdadm" ]
    ) ++ (
      optionals ({} != config.networking.bonds) [ "bonding" ]
    ) ++ (
      optionals (mountsFileSystemType "nfs") [ "nfs" ]
    ) ++ (
      optionals (mountsFileSystemType "xfs") [ "xfs" ]
    ) ++ (
      optionals (mountsFileSystemType "zfs" || elem "zfs" config.boot.supportedFilesystems) [ "zfs" ]
    );
  };
}

