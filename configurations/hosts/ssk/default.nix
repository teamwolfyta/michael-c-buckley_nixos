# Persistent USB NVMe install
#  Uncreatively, SSK is just the name of the enclosure
{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.nix-secrets.nixosModules.t14
    ./hardware
  ];

  networking.hostId = "fd78a12b";

  programs = {
    cosmic.enable = true;
    hyprland.enable = true;
  };

  # Gnome for the environment
  services.xserver.desktopManager.gnome.enable = true;

  environment.systemPackages = with pkgs; [
    brightnessctl
    talosctl
    devenv
    nixos-anywhere
  ];

  features = {
    michael = {
      extendedGraphical = true;
      vscode.enable = true;
      waybar.enable = true;
      hyprland.enable = true;
      nvf.package = "default";
    };
    autoLogin = false;
    displayManager = "greetd";
    gaming.enable = false;
    pkgs.fonts = true;
  };

  system = {
    preset = "laptop";
    stateVersion = "25.05";
    impermanence.enable = true;
    zfs = {
      enable = true;
      encryption = true;
    };
  };
}
