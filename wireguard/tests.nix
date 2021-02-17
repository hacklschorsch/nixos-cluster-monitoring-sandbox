# Scope: Test the management network.
# Usage: 

let

  pkgs = import <nixpkgs> { };
  pingCmd = "ping -c5 -W1";

in {
  vm-monitoring = pkgs.nixosTest {

    nodes = import ./network.nix;

    testScript = ''
      start_all()

      node1.wait_for_unit("network-online.target")
      node2.wait_for_unit("network-online.target")
      node3.wait_for_unit("network-online.target")

      # node1.wait_for_unit("wg0.service")
      # node2.wait_for_unit("wg0.service")
      # node3.wait_for_unit("wg0.service")

      # The underlying network must function
      node1.succeed("${pingCmd} node1")
      node1.succeed("${pingCmd} node2")
      node1.succeed("${pingCmd} node3")

      # The wireguard server is able to ping itself and all clients
      node1.succeed("${pingCmd} 192.168.42.1")
      node1.succeed("${pingCmd} 192.168.42.2")
      node1.succeed("${pingCmd} 192.168.42.3")

      # The clients are able to ping themself
      node2.succeed("${pingCmd} 192.168.42.2")
      node3.succeed("${pingCmd} 192.168.42.3")

      # The clients are able to ping the server
      node2.succeed("${pingCmd} 192.168.42.1")
      node3.succeed("${pingCmd} 192.168.42.1")

      # The wireguard server should not do any routing
      node2.fail("${pingCmd} 192.168.42.3")
    '';
  };
}

