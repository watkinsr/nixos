{ pkgs, ... }: {
  imports = [
    #./alacritty
    #./android
    #./chromium
    #./element
    ./emacs
    ./firefox
    ./foot
    #./greetd
    #./video-streaming
    ./pipewire
    #./redshift
    ./spotify
    #./sway
    ./slack
    #./waybar
  ];

  home-manager.users.ryan = {
    home.sessionVariables = {
      MOZ_ENABLE_WAYLAND = 1;
      XDG_SESSION_TYPE = "wayland";
      XDG_DATA_DIRS = with pkgs; "${pkgs.gnome3.adwaita-icon-theme}/share:$XDG_DATA_DIRS";
    };

    programs = { mako.enable = true; };
  };

  programs = {
    light.enable = true;
    #qt5ct.enable = true;
  };

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        #xdg-desktop-portal-gtk
      ];
      gtkUsePortal = true;
    };
  };

  security.rtkit.enable = true;

  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      extraPackages = with pkgs; [
        vaapiIntel
        intel-media-driver
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
  };

  systemd.services.lock-before-sleeping = {
    restartIfChanged = false;
    unitConfig = {
      Description = "Helper service to bind locker to sleep.target";
    };
    serviceConfig = {
      ExecStart =
        "${pkgs.swaylock-effects}/bin/swaylock --screenshots --clock --indicator --indicator-radius 100 --indicator-thickness 7 --effect-blur 7x5 --effect-vignette 0.5:0.5 --ring-color bb00cc --key-hl-color 880033 --line-color 00000000 --inside-color 00000088 --separator-color 00000000 --grace 2 --fade-in 0.2";
      Type = "simple";
      User = "ryan";
    };
    before = [ "pre-sleep.service" ];
    wantedBy = [ "pre-sleep.service" ];
    environment = {
      DISPLAY = ":1";
      WAYLAND_DISPLAY = "wayland-1";
      XDG_RUNTIME_DIR = "/run/user/1000";
    };
  };

  fonts = {
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    fontconfig = {
      enable = true;
      defaultFonts = { monospace = [ "Inconsolata" ]; };
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
      cantarell-fonts
    ];
  };

  environment = {
    pathsToLink = [ "/libexec" ];
    systemPackages = with pkgs; [
      speedcrunch
      libnotify
      polkit_gnome
      brillo
      xwayland
      swaylock-effects
      swayidle
      wl-clipboard
      wofi
      kanshi
      wev
      wf-recorder
      linuxPackages.v4l2loopback
      slurp
      wlogout
      grim
      ncmpcpp
      youtube-dl
      yle-dl
      flac
      mpv
      evince
      gnome3.eog
      deadbeef
      libva-utils
      libreoffice
      psensor
      lagrange
      feh
      dmidecode
      lm_sensors
      polkit_gnome
      linux-pam
      qt5.qtwayland
      brightnessctl
    ];
  };
}
