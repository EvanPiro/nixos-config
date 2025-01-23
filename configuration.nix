{
  config,
  pkgs,
  lib,
  inputs,
  mypkgs,
  nixvim,
  ...
}: {
  nixpkgs = {
    config = {
      allowBroken = true;
      allowUnfree = true;
    };
  };

  nixpkgs.overlays = [
    (self: super: {
      fcitx-engines = pkgs.fcitx5;
    })
  ];

  nix = {
    nixPath = ["nixpkgs=${inputs.nixpkgs}"];
    registry.nixpkgs.flake = inputs.nixpkgs;

    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    settings.trusted-users = ["root" "evan"];
  };

  swapDevices = [
    {
      device = "/swapfile";
      size = 16 * 1024;
    }
  ];

  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 7;
      };
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_latest;
  };

  networking = {
    hostName = "tower";
    useDHCP = false;
    interfaces.enp11s0.useDHCP = true;
    firewall.enable = true;
  };

  systemd.services.NetworkManager-wait-online.enable = false;

  time.timeZone = "America/New_York";

  services = {
    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
      libinput.enable = true;
    };
    tailscale.enable = true;
    openssh.enable = true;
  };

  virtualisation.docker.enable = true;

  users.users.evan = {
    isNormalUser = true;
    initialPassword = "p123";
    extraGroups = ["wheel" "docker"]; # Enable ‘sudo’ for the user.
  };

  users.extraGroups.docker.members = [ "evan" ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; let
    pgprove = perlPackages.TAPParserSourceHandlerpgTAP;
  in [
    wget
    nixvim
    firefox
    nano
    mattermost-desktop
    git
    vscode
    cachix
    htop
    unzip
    gotop
    ranger
    tmate
    gcc
    cargo
    tdesktop
    tmux
    go
    ncdu
    vlc
    audacity
  ];
  environment.variables.EDITOR = "nvim";

  environment.sessionVariables = rec {
    XDG_CACHE_HOME = "\${HOME}/.cache";
    XDG_CONFIG_HOME = "\${HOME}/.config";
    XDG_BIN_HOME = "\${HOME}/.local/bin";
    XDG_DATA_HOME = "\${HOME}/.local/share";
    PATH = [
      "\${XDG_BIN_HOME}"
    ];
  };

  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    neovim.defaultEditor = true;
    java.enable = true;
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?
}
