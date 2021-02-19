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

      server.wait_for_unit("network-online.target")
      node1.wait_for_unit("network-online.target")
      node2.wait_for_unit("network-online.target")

      server.wait_for_unit("wireguard-monitoringvpn.service")
      node1.wait_for_unit("wireguard-monitoringvpn.service")
      node2.wait_for_unit("wireguard-monitoringvpn.service")

      server.wait_for_unit("sys-subsystem-net-devices-monitoringvpn.device")
      node1.wait_for_unit("sys-subsystem-net-devices-monitoringvpn.device")
      node2.wait_for_unit("sys-subsystem-net-devices-monitoringvpn.device")

      # The underlying network must function
      server.succeed("${pingCmd} server")
      server.succeed("${pingCmd} node1")
      server.succeed("${pingCmd} node2")

      # The clients are able to ping themselves
      node1.succeed("${pingCmd} 192.168.42.11")
      node2.succeed("${pingCmd} 192.168.42.12")

      # The clients are able to ping the server
      node1.succeed("${pingCmd} 192.168.42.1")
      node2.succeed("${pingCmd} 192.168.42.1")

      # The wireguard server should not do any routing
      node1.fail("${pingCmd} 192.168.42.12")

      # The wireguard server is able to ping itself and all clients
      # IDK why, but when these tests come first, they fail.
      server.succeed("${pingCmd} 192.168.42.1")
      server.succeed("${pingCmd} 192.168.42.11")
      server.succeed("${pingCmd} 192.168.42.12")
    '';
  };
}

