# Scope: Test the management network.
# Usage: $ nix-build tests.nix

let

  pkgs = import <nixpkgs> { };
  pingCmd = "ping -c1 -W1";

in {
  vm-monitoring = pkgs.nixosTest {

    nodes = import ./network.nix;

    testScript = ''
      start_all()

      node1.wait_for_unit("network-online.target")
      node2.wait_for_unit("network-online.target")
      node3.wait_for_unit("network-online.target")

      node1.wait_for_unit("wireguard-monitoringvpn.service")
      node2.wait_for_unit("wireguard-monitoringvpn.service")
      node3.wait_for_unit("wireguard-monitoringvpn.service")

      node1.wait_for_unit("sys-subsystem-net-devices-monitoringvpn.device")
      node2.wait_for_unit("sys-subsystem-net-devices-monitoringvpn.device")
      node3.wait_for_unit("sys-subsystem-net-devices-monitoringvpn.device")

      # The underlying network must function
      node1.succeed("${pingCmd} node1")
      node1.succeed("${pingCmd} node2")
      node1.succeed("${pingCmd} node3")

      # The clients are able to ping themselves
      node2.succeed("${pingCmd} 192.168.42.2")
      node3.succeed("${pingCmd} 192.168.42.3")

      # The clients are able to ping the server
      node2.succeed("${pingCmd} 192.168.42.1")
      node3.succeed("${pingCmd} 192.168.42.1")

      # The wireguard server should not do any routing
      node2.fail("${pingCmd} 192.168.42.3")

      # The wireguard server is able to ping itself and all clients
      # IDK why, but when these tests come first, they fail.
      node1.succeed("${pingCmd} 192.168.42.1")
      node1.succeed("${pingCmd} 192.168.42.2")
      node1.succeed("${pingCmd} 192.168.42.3")
    '';
  };
}

