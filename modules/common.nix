# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      ./file-systems.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    loader.systemd-boot.enable = true;
    loader.grub.copyKernels = true;
    loader.efi.canTouchEfiVariables = true;
    kernelPackages = pkgs.linuxPackages_latest;
    supportedFilesystems = [ "zfs" ];
  };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  networking = {
    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;
    networkmanager.enable = true;

    timeServers = [
      "0.de.pool.ntp.org"
      "1.de.pool.ntp.org"
      "2.de.pool.ntp.org"
      "3.de.pool.ntp.org"
    ];
  };

  programs.light.enable = true;
  programs.qt5ct.enable = true;

  nixpkgs.config.allowUnfree = true;

  # Enable sound.
  sound.enable = true;

  hardware = {
    pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
    };
    bluetooth.enable = true;
    opengl = {
      driSupport = true;
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.pimeys = {
     isNormalUser = true;
     shell = pkgs.fish;
     extraGroups = [
       "wheel"
       "video"
       "networkmanager"
       "docker"
     ];
  };

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
      gtkUsePortal = true;
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     wget
     neovim
     emacs
     brightnessctl
     polkit_gnome
     gtk-engine-murrine
     gtk_engines
     gsettings-desktop-schemas
     lxappearance
     fish
     htop
     thefuck
     git
     perl
     sysstat
     element-desktop
     docker-compose
     rustup
     ncmpcpp
     clang
     zlib
     binutils
     openssl
     automake
     gnumake
     rust-analyzer
     ripgrep
     fd
     pavucontrol
     youtube-dl
     tree
     tmux
     unzip
     blueman
     openjdk
     jetbrains.datagrip
     jetbrains.idea-community
     android-studio
     google-cloud-sdk
     qt5.qtwayland
     lm_sensors
     ffmpeg
     flac
     zoom-us
     spotify
     ncmpcpp
     slack
     python3
     bat
     mpv
     home-manager
     home-assistant-cli
     evince
     gnome3.eog
     signal-desktop
     niv
     jq
     nodejs-slim
     bc
  ];

  environment.pathsToLink = [ "/libexec" ];

  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [
          "Inconsolata"
        ];
      };
    };
    fonts = with pkgs; [
      corefonts
      inconsolata
      ubuntu_font_family
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      liberation_ttf
      fira-code
      fira-code-symbols
      mplus-outline-fonts
      dina-font
      proggyfonts
      awesome
      dejavu_fonts
      nerdfonts
      hack-font
    ];
  };

  virtualisation.docker.enable = true;

  services = {
    zfs = {
      trim.enable = true;
      autoScrub.enable = true;
    };
    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
    };
  };

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than-7d";
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

}

