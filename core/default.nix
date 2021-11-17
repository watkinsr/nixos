{ config, pkgs, inputs, ... }:

{
  imports = [
    ../cachix.nix
    ./databases
    ./docker
    ./fish
    ./git
    ./javascript
    ./nvim
    ./rust
    ./systools
    ./tmux
  ];

  services.sshd.enable = true;

  nixpkgs.config = {
    allowUnfree = true;
    allowBroken = true;
  };

  system = {
    stateVersion = "20.09";
    activationScripts.diff = ''
      ${pkgs.nixUnstable}/bin/nix store \
        --experimental-features 'nix-command' \
        diff-closures /run/current-system "$systemConfig"
    '';
  };

  home-manager.users.ryan.programs = {
    ssh = { enable = true; };
    direnv = {
      enable = true;
      enableFishIntegration = true;
      nix-direnv = { enable = true; };
    };
    mcfly = {
      enable = true;
      enableFishIntegration = true;
      enableFuzzySearch = true;
      keyScheme = "vim";
    };
    starship = {
      enable = true;
      enableFishIntegration = true;
    };
  };

  services = {
    avahi = { enable = true; };
    haveged.enable = true;
    xserver = { 
      enable = true; 
      extraLayouts.us-watkinsr = {
        description = "us-watkinsr";
        languages = [ "eng" ];
        symbolsFile = /root/us-watkinsr;

      };
      displayManager = {
        #sessionPackages = [
        #  (pkgs.plasma-workspace.overrideAttrs
        #    (old: { passthru.providedSessions = [ "plasmawayland" ]; }))
        #  ];
        # sddm.enable = true;
        gdm.enable = true;
      };
      desktopManager = {
        # plasma5.enable = true;
        gnome.enable = true;
      };
    };
    teamviewer = { enable = true; };
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
      keep-outputs = true
      keep-derivations = true
    '';
  };

  users.users.ryan = {
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
      "adbusers"
    ];
  };

  # Use the systemd-boot EFI boot loader.
  boot = {
    loader = {
      grub = {
        enable = true;
        copyKernels = true;
        efiSupport = true;
        useOSProber = true;
        device = "nodev";
        configurationLimit = 10;
      };
      efi = { canTouchEfiVariables = true; };
    };

    kernelPackages = pkgs.linuxPackages_latest;

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

  networking = {
    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;
    networkmanager.enable = true;

    firewall.checkReversePath = "loose";

    timeServers = [
      "0.de.pool.ntp.org"
      "1.de.pool.ntp.org"
      "2.de.pool.ntp.org"
      "3.de.pool.ntp.org"
    ];
  };

  environment = {
    pathsToLink = [ "/libexec" "/share/fish" ];
    systemPackages = with pkgs; [
      nvd
      rnix-lsp
      cachix
      home-manager
      man-db
      pciutils
      libqrencode
      any-nix-shell
      nixfmt
      ansible
      gnumake
      python3
      inputs.agenix.defaultPackage.x86_64-linux
      lm_sensors
      unixtools.xxd
      fzf
      signal-desktop
    ];
  };
}
