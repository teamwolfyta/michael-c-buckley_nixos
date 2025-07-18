{
  config,
  lib,
  inputs,
  ...
}: let
  inherit (lib) mkDefault optionals;
  inherit (config.networking) loopback;

  addr = addr: prefix: {
    address = addr;
    prefixLength = prefix;
  };
in {
  imports = [
    inputs.nix-secrets.nixosModules.network.hosts
    ./bgp.nix
    ./eigrp.nix
    ./options.nix
    ./ospf.nix
    ./unbound.nix
    ./vrrp.nix
    ./vxlan.nix
  ];

  services = {
    lldpd.enable = mkDefault true;
    # Set sane standards on file descriptor limits for FRR daemons
    frr = {
      bgpd.options = mkDefault ["--limit-fds 2048"];
      zebra.options = mkDefault ["--limit-fds 2048"];
      openFilesLimit = mkDefault 2048;
    };
  };

  # Apply the loopback address if added
  networking.interfaces.lo.ipv4.addresses = optionals (loopback.ipv4 != null) [
    (addr loopback.ipv4 32)
  ];
}
