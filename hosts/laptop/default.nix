{ config, pkgs, user, ... }:

{
  imports =                                               # For now, if applying to other system, swap files
    [(import ./hardware-configuration.nix)] ++            # Current system hardware config @ /etc/nixos/hardware-configuration.nix
    [(import ../../modules/desktop/hyprland/default.nix)] ++ # Window Manager
    [(import ../../modules/desktop/virtualisation/docker.nix)] ++  # Docker
    (import ../../modules/hardware);                      # Hardware devices

  boot = {                                  # Boot options
    kernelPackages = pkgs.linuxPackages_latest;

    loader = {                              # EFI Boot
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      grub = {                              # Most of grub is set up for dual boot
        enable = true;
        version = 2;
        devices = [ "nodev" ];
        efiSupport = true;
        useOSProber = true;                 # Find all boot options
        configurationLimit = 5;
      };
      timeout = 3;                          # Grub auto select time
    };
  };

  environment = {
    systemPackages = with pkgs; [
    ];
  };

  programs = {                              # No xbacklight, this is the alterantive
    dconf.enable = true;
    light.enable = true;
  };

  services = {
    tlp.enable = true;                      # TLP and auto-cpufreq for power management
    #logind.lidSwitch = "ignore";           # Laptop does not go to sleep when lid is closed
    auto-cpufreq.enable = true;
    blueman.enable = true;
  };

  #temporary bluetooth fix
  systemd.tmpfiles.rules = [
    "d /var/lib/bluetooth 700 root root - -"
  ];
  systemd.targets."bluetooth".after = ["systemd-tmpfiles-setup.service"];
}
