# nixos-cluster-monitoring-sandbox

In here I learn how to set up network monitoring using Nix and Prometheus/Grafana/Loki and run experiments.

## Usage

On current NixOS, build and start VMs:

    $ nixos-build-vms network.nix
    $ ./result/bin/nixos-test-driver

In the resulting REPL, enter `start_all()`.

## Links

  * [Xe's 2020-11-20 article on Prometheus on NixOS](https://christine.website/blog/prometheus-grafana-loki-nixos-2020-11-20)
  * [The NixOS Prometheus tests](https://github.com/NixOS/nixpkgs/blob/master/nixos/tests/prometheus.nix)
  * [The Mayflower Prometheus monitoring configuration](https://github.com/mayflower/nixexprs/tree/master/modules/monitoring)

