{ pkgs, ... }: {
  imports = [
    ./emacs
    ./firefox
    ./spotify
    ./slack
  ];

  programs = {
    light.enable = true;
  };

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        #xdg-desktop-portal-wlr
        xdg-desktop-portal-kde
        #xdg-desktop-portal-gtk
      ];
      #gtkUsePortal = true;
    };
  };

  security.rtkit.enable = true;

  hardware = {
    pulseaudio = {
      enable = true;
    };
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
      libnotify
      linuxPackages.v4l2loopback
      grim
      youtube-dl
      yle-dl
      flac
      mpv
      libva-utils
      libreoffice
      psensor
      dmidecode
      lm_sensors
      linux-pam
      brightnessctl
      #ncmpcpp
      #lagrange
      #polkit_gnome
      #wl-clipboard
      #wofi
      #wf-recorder
      #qt5.qtwayland
      #feh
      #polkit_gnome
      #xwayland
      #swaylock-effects
      #swayidle
      #kanshi
      #wev
      #evince
      #gnome3.eog
      #deadbeef
      #slurp
      #wlogout
      #speedcrunch
      #brillo
    ];
  };
}
