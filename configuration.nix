{
  config,
  pkgs,
  lib,
  inputs,
  mypkgs,
  ...
}: {
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };


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

  # Set your time zone.
  time.timeZone = "America/New_York";

  services = {
    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
      libinput.enable = true;
      videoDrivers = [ "nvidia" ];
    };
    tailscale.enable = true;
    openssh.enable = true;
  };

  security.acme.acceptTerms = true;


  virtualisation.docker.enable = true;

  # Enable sound.
 #  hardware.pulseaudio.enable = true;

  # Define a user account.
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
    neovim
    wget
    google-chrome
    chromium
    nano
    mattermost-desktop
    git
    vscode
    cachix
    htop
    unzip
    gotop
    mosh
    ranger
    tmate
    graphviz
    rustc
    gcc
    cargo
    tdesktop
    tmux
    gdb
    ncdu
    ctags
    vlc
    rustup
    (steam.override {
      withPrimus = true;
      extraPkgs = pkgs: [bumblebee glxinfo];
    })
    .run
    (steam.override {withJava = true;})
  ];
  environment.variables.EDITOR = "vim";

  environment.sessionVariables = rec {
    XDG_CACHE_HOME = "\${HOME}/.cache";
    XDG_CONFIG_HOME = "\${HOME}/.config";
    XDG_BIN_HOME = "\${HOME}/.local/bin";
    XDG_DATA_HOME = "\${HOME}/.local/share";
    # Steam needs this to find Proton-GE
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
    # note: this doesn't replace PATH, it just adds this to it
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

    # Makes SSH terminal faster
    mosh.enable = true;

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
