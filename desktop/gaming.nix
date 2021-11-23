{ config, lib, pkgs, ... }:

{
  environment = {
    systemPackages = with pkgs; [
      lutris 
      vulkan-tools 
      wineWowPackages.stable 
      mesa-demos
      phoronix-test-suite
    ];
    variables.RADV_PERFTEST = "nggc";
  };

  programs = { steam.enable = true; };

  hardware = {
    opengl = {
      driSupport32Bit = true;
      enable = true;
    };
  };
}
