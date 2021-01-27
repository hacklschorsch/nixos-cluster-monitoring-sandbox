# Scope: Test the monitoring stack. (Have some nice scrolling text.)

let
  pkgs = import <nixpkgs> { };
in {
  vm-monitoring = pkgs.nixosTest {

    nodes = import ./network.nix;

    # WIP, random test script so far: wait for SSH, so there's something
    # on the screen.
    testScript = ''
      start_all()
      grafana.forward_port(2342, 2342)
      node1.wait_for_unit("sshd")
    '';
  };
}

