# Promtail systemd service
#
# Scope: Tail logs to central `Loki` logs aggregator
# See https://christine.website/blog/prometheus-grafana-loki-nixos-2020-11-20

{ config, lib, pkgs, ... }:
let

  cfg = config.services.private-storage.monitoring.promtail;

  promtailConfig = {
    server = {
      grpc_listen_port = 0;
      http_listen_port = 3101;
    };

    clients = [{ url = cfg.lokiUrl; }];

    positions = { filename = "/tmp/positions.yaml"; };

    scrape_configs = [{
      job_name = "journal";
      journal = {
        max_age = "12h";
          labels = {
          job = "systemd-journal";
          host = config.networking.hostName;
        };
      };
      relabel_configs = [
        {
          source_labels = [ "__journal__systemd_unit" ];
          target_label = "unit";
        }
      ];
    }];
  };

  promtailConfigFile = pkgs.writeText "promtail.json" (builtins.toJSON promtailConfig);

in {
  options.services.private-storage.monitoring.promtail = {
    lokiUrl = lib.mkOption
    { type = lib.types.str;
      example = lib.literalExample "http://loki:3100/loki/api/v1/push";
      default = "http://loki:3100/loki/api/v1/push";
      description = "The URL of the Loki host to send the logs to";
    };
  };

  config = {
    systemd.services.promtail = {
      description = "Promtail service for Loki";
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = "${pkgs.grafana-loki}/bin/promtail --config.file ${promtailConfigFile}";
        # I have a feeling we might need those, curtesy of
        # https://github.com/input-output-hk/bitte/blob/master/modules/promtail.nix
        # Restart = "on-failure";
        # RestartSec = "20s";
        # SuccessExitStatus = 143;
        # StateDirectory = "promtail";
        # # DynamicUser = true;
        # # User = "promtail";
        # # Group = "promtail";
      };
    };
  };
}

