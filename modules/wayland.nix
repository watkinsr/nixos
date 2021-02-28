{ config, lib, pkgs, ... }:

{
  boot.kernelModules = [ "v4l2loopback" ];

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true; # so that gtk works properly
    extraPackages = with pkgs; [
      xwayland
      swaylock
      swayidle
      wl-clipboard
      mako # notification daemon
      wofi
      waybar
      kanshi
      i3blocks-gaps
      i3status
      wev
      wf-recorder
      linuxPackages.v4l2loopback
    ];
    extraSessionCommands = ''
      export _JAVA_AWT_WM_NONREPARENTING=1;
      export SDL_VIDEODRIVER=wayland
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      export HASS_SERVER="http://hass.local:8123";
      export MOZ_ENABLE_WAYLAND="1";
      export XDG_SESSION_TYPE="wayland";
      source $HOME/.config/nixpkgs/secret/secret;
    '';
  };

  services.xserver.displayManager.gdm.wayland = true;

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

  environment.systemPackages = with pkgs; [
     firefox-wayland
     wl-clipboard
  ];
}
