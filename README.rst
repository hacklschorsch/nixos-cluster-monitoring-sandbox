nixos-cluster-monitoring-sandbox
================================

In here I learn how to set up network monitoring using Nix and
Prometheus/Grafana/Loki and run experiments.

I am using the `20.09 <https://nixos.org/channels/nixos-20.09>`__ NixOS channel.

Usage
-----

On current NixOS, build and start VMs:

::

   $ nixos-build-vms network.nix
   $ ./result/bin/nixos-test-driver

In the resulting REPL, enter:

::

   start_all()
   grafana.forward_port(8080,80)

And open http://localhost:8080/ in your browser to view Grafana.

Links
-----

This is drawing inspiration and sometimes blatantly copying from

-  `Xe’s 2020-11-20 article on Prometheus on
   NixOS <https://christine.website/blog/prometheus-grafana-loki-nixos-2020-11-20>`__
-  `The NixOS Prometheus
   tests <https://github.com/NixOS/nixpkgs/blob/master/nixos/tests/prometheus.nix>`__
-  `The Mayflower Prometheus monitoring
   configuration <https://github.com/mayflower/nixexprs/tree/master/modules/monitoring>`__
-  `The IOHK Bitte repo <https://github.com/input-output-hk/bitte/>`__

