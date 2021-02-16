# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./thinkpad-t25.nix
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

  # networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true; # so that gtk works properly
    extraPackages = with pkgs; [
      xwayland
      swaylock
      swayidle
      wl-clipboard
      mako # notification daemon
      alacritty # Alacritty is the default terminal in the config
      wofi
      waybar
      kanshi
      i3blocks-gaps
      i3status
      wev
    ];
    extraSessionCommands = ''
      export _JAVA_AWT_WM_NONREPARENTING=1;
      export SDL_VIDEODRIVER=wayland
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
    '';
  };

  programs.light.enable = true;
  programs.qt5ct.enable = true;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    (self: super: {
      wl-clipboard-x11 = super.stdenv.mkDerivation rec {
      pname = "wl-clipboard-x11";
      version = "5";
    
      src = super.fetchFromGitHub {
        owner = "brunelli";
        repo = "wl-clipboard-x11";
        rev = "v${version}";
        sha256 = "1y7jv7rps0sdzmm859wn2l8q4pg2x35smcrm7mbfxn5vrga0bslb";
      };
    
      dontBuild = true;
      dontConfigure = true;
      propagatedBuildInputs = [ super.wl-clipboard ];
      makeFlags = [ "PREFIX=$(out)" ];
      };
    
      xsel = self.wl-clipboard-x11;
      xclip = self.wl-clipboard-x11;
    })
  ];


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
     ]; # Enable ‘sudo’ for the user.
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     wget
     neovim
     firefox-wayland
     emacs
     wl-clipboard
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
     google-cloud-sdk
     qt5.qtwayland
     lm_sensors
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
    tlp = { enable = true; };
    zfs = {
      trim.enable = true;
      autoScrub.enable = true;
    };
    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
    };
  };

  systemd.services.lock-before-sleeping = {
    restartIfChanged = false;
    unitConfig = {
      Description = "Helper service to bind locker to sleep.target";
    };
    serviceConfig = {
      ExecStart = "${pkgs.swaylock}/bin/swaylock -i /home/pimeys/Pictures/Ve0XkQ4.jpg";
      Type = "simple";
      User = "pimeys";
    };
    before = [
      "pre-sleep.service"
    ];
    wantedBy= [
      "pre-sleep.service"
    ];
    environment = {
      XDG_RUNTIME_DIR = "/run/user/1000";
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

