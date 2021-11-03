{ config, pkgs, inputs, ... }:

{
  programs.light.enable = true;
  programs.qt5ct.enable = true;

  hardware = {
    bluetooth.enable = true;
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

  environment.systemPackages = with pkgs; [
    alacritty
    bind
    blueman
    bottom
    brightnessctl
    chafa
    discord
    dmidecode
    dust
    element-desktop
    feh
    fish
    gsettings-desktop-schemas
    gtk-engine-murrine
    gtk_engines
    home-assistant-cli
    lm_sensors
    lxappearance
    openssl
    polkit_gnome
    qt5.qtwayland
    signal-desktop
    speedcrunch
    sysstat
    tealdeer
    tdesktop
    thefuck
    xsv
    zip
    zstd
    libuchardet
    pciutils
    libqrencode
    linux-pam
    nixfmt
  ];
}
