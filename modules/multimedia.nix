{ config, lib, pkgs, ... }:

{
  sound.enable = true;
  security.rtkit.enable = true;

  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
     ncmpcpp
     youtube-dl
     ffmpeg
     flac
     spotify
     mpv
     evince
     gnome3.eog
  ];
}
