{
  config,
  lib,
  inputs,
  ...
}: let
  inherit (lib) mkDefault mkEnableOption mkOption mkIf;
  inherit (lib.types) nullOr str;
  inherit (config.system) disko;
  mainDisko = disko.main;
in {
  imports = [inputs.disko.nixosModules.disko];

  options = {
    system.disko = {
      enable = mkEnableOption "Enable Disko for this host.";
      main = {
        device = mkOption {
          type = nullOr str;
          default = null;
          description = "Activate Disko by declaring the primary drive.";
        };
        bootSize = mkOption {
          type = str;
          default = "500M";
          description = "What size to create the boot partition.";
        };
        swapSize = mkOption {
          type = str;
          default = "1G";
          description = "Swap partition size.";
        };
        rootSize = mkOption {
          type = str;
          default = "1G";
          description = "Size of the root tmpfs.";
        };
        imageSize = mkOption {
          type = nullOr str;
          default = "2G";
          description = "Size of VM image to be created, if making a VM.";
        };
        zfsSize = mkOption {
          type = str;
          default = "100%";
          description = "What size to use on the ZFS volume.";
        };
      };
    };
  };

  config = mkIf disko.enable {
    # This uses ZFS so activate it if needed
    system.zfs.enable = mkDefault true;

    # Add the filesystems we'll need to boot
    fileSystems = {
      "/persist".neededForBoot = true;
      "/cache".neededForBoot = true;
    };

    disko.devices = {
      disk."main" = {
        type = "disk";
        inherit (mainDisko) imageSize device;

        content = {
          type = "gpt";
          partitions = import ./partitions.nix {inherit config;};
        };
      };
      zpool."zroot" = import ./zroot.nix;
      nodev = import ./nodevs.nix {inherit config;};
    };
  };
}
