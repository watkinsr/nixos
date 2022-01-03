{ pkgs, ... }:

{
  hardware.bluetooth.enable = true;
  sound.enable = true;
  environment.systemPackages = with pkgs; [
    blueman
  ];
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = true;
  };
}
