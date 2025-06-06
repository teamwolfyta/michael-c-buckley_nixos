{
  self,
  overlays,
}: let
  inherit (self) inputs;
  # Build the configs for the hosts based on this function
  clusterConfig = {
    cluster,
    host,
    extraModules ? [],
  }: let
    system =
      if host == "o1"
      then "aarch64-linux"
      else "x86_64-linux";
    pkgs = import inputs.nixpkgs {
      inherit system;
    };
    inherit (inputs.nixpkgs) lib;
    customLib = import ../lib {inherit pkgs lib;};
  in
    inputs.nixpkgs.lib.nixosSystem {
      # Oracle1 is an exception as it is an ARM host
      inherit system;
      specialArgs = {inherit self customLib lib host system inputs overlays;};
      modules =
        [
          ./modules
          ./clusters/${cluster}
          ./clusters/${cluster}/hosts/${host}
          ./user/hjem.nix
        ]
        ++ extraModules;
    };

  generateCluster = {
    cluster,
    hostPrefix ? cluster,
    extraModules ? [],
    max,
  }:
    builtins.listToAttrs (
      builtins.genList (
        i: let
          number = i + 1;
          host = "${hostPrefix}${toString number}";
        in {
          name = host;
          value = clusterConfig {inherit cluster host extraModules;};
        }
      )
      max
    );
in
  generateCluster {
    cluster = "uff";
    extraModules = [./modules/presets/michael.nix];
    max = 3;
  }
  // generateCluster {
    cluster = "oracle";
    hostPrefix = "o";
    extraModules = [./modules/presets/michael.nix];
    max = 3;
  }
  // generateCluster {
    cluster = "ln";
    max = 3;
  }
  // generateCluster {
    cluster = "sff";
    extraModules = [./modules/presets/michael.nix];
    max = 3;
  }
