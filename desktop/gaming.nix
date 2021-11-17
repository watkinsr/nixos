{ config, lib, pkgs, ... }:

{
  environment = {
    systemPackages = with pkgs; [ lutris vulkan-tools ];
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
