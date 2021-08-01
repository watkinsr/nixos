{ config, pkgs, inputs, ... }:

{
  imports = [ ../cachix.nix ];

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "20.09";

  services = {
    avahi = {
      enable = true;
    };
    haveged.enable = true;
    zfs = {
      trim.enable = true;
      autoScrub.enable = true;
    };
    xserver = {
      enable = true;
    };
    tailscale = {
      enable = true;
      package = pkgs.master.tailscale;
    };
  };

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than-7d";
    };

    sandboxPaths = [ "/bin/sh=${pkgs.bash}/bin/sh" ];
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  users.users.pimeys = {
    description = "The primary user account";
    isNormalUser = true;
    shell = pkgs.fish;
    uid = 1000;
    extraGroups = [
      "wheel"
      "video"
      "networkmanager"
      "docker"
      "scanner"
      "libvirtd"
      "kvm"
      "input"
    ];
  };

  # Use the systemd-boot EFI boot loader.
  boot = {
    loader = {
      grub = {
        enable = true;
        copyKernels = true;
        zfsSupport = true;
        efiSupport = true;
        useOSProber = true;
        device = "nodev";
        configurationLimit = 10;
      };
      efi = {
        canTouchEfiVariables = true;
      };
    };

    kernelPackages = pkgs.master.linuxPackages_latest;
    supportedFilesystems = [ "zfs" ];

    zfs.enableUnstable = true;

    kernelModules = [ "tcp_bbr" ];

    kernel.sysctl = {
      # The Magic SysRq key is a key combo that allows users connected to the
      # system console of a Linux kernel to perform some low-level commands.
      # Disable it, since we don't need it, and is a potential security concern.
      "kernel.sysrq" = 0;

      ## TCP hardening
      # Prevent bogus ICMP errors from filling up logs.
      "net.ipv4.icmp_ignore_bogus_error_responses" = 1;
      # Reverse path filtering causes the kernel to do source validation of
      # packets received from all interfaces. This can mitigate IP spoofing.
      "net.ipv4.conf.default.rp_filter" = 1;
      "net.ipv4.conf.all.rp_filter" = 1;
      # Do not accept IP source route packets (we're not a router)
      "net.ipv4.conf.all.accept_source_route" = 0;
      "net.ipv6.conf.all.accept_source_route" = 0;
      # Don't send ICMP redirects (again, we're on a router)
      "net.ipv4.conf.all.send_redirects" = 0;
      "net.ipv4.conf.default.send_redirects" = 0;
      # Refuse ICMP redirects (MITM mitigations)
      "net.ipv4.conf.all.accept_redirects" = 0;
      "net.ipv4.conf.default.accept_redirects" = 0;
      "net.ipv4.conf.all.secure_redirects" = 0;
      "net.ipv4.conf.default.secure_redirects" = 0;
      "net.ipv6.conf.all.accept_redirects" = 0;
      "net.ipv6.conf.default.accept_redirects" = 0;
      # Protects against SYN flood attacks
      "net.ipv4.tcp_syncookies" = 1;
      # Incomplete protection again TIME-WAIT assassination
      "net.ipv4.tcp_rfc1337" = 1;

      ## TCP optimization
      # TCP Fast Open is a TCP extension that reduces network latency by packing
      # data in the sender’s initial TCP SYN. Setting 3 = enable TCP Fast Open for
      # both incoming and outgoing connections:
      "net.ipv4.tcp_fastopen" = 3;
      # Bufferbloat mitigations + slight improvement in throughput & latency
      "net.ipv4.tcp_congestion_control" = "bbr";
      "net.core.default_qdisc" = "cake";
    };
  };

  environment.pathsToLink = [ "/libexec" ];
  networking = {
    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;
    networkmanager.enable = true;
    firewall = {
      enable = true;
      trustedInterfaces = [ "tailscale0" ];
      allowedUDPPorts = [ 41641 ];
    };

    timeServers = [
      "0.de.pool.ntp.org"
      "1.de.pool.ntp.org"
      "2.de.pool.ntp.org"
      "3.de.pool.ntp.org"
    ];
  };

  programs.light.enable = true;
  programs.qt5ct.enable = true;

  hardware = {
    bluetooth.enable = true;
    opengl = {
      driSupport = true;
    };
  };

  environment.systemPackages = with pkgs; [
    alacritty
    bat
    bc
    bind
    blueman
    bottom
    brightnessctl
    cachix
    discord
    dmidecode
    dust
    element-desktop
    exa
    fd
    feh
    fish
    groff
    gsettings-desktop-schemas
    gtk-engine-murrine
    gtk_engines
    home-assistant-cli
    home-manager
    htop
    jq
    lm_sensors
    lxappearance
    man-db
    mc
    openssl
    polkit_gnome
    qt5.qtwayland
    signal-desktop
    speedcrunch
    starship
    sysstat
    tealdeer
    tdesktop
    thefuck
    tmux
    tree
    unzip
    wget
    xsv
    zip
    zstd
    file
    libuchardet
    pciutils
    libqrencode
    master.tailscale
    linux-pam
  ];
}
