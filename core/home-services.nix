{ config, lib, pkgs, ... }:

{
  services = {
    # lpadmin -p Brother -E -v ipp://10.0.0.17/ipp -m everywhere
    printing = {
      enable = true;
      allowFrom = [ "localhost" "muspus" "naunau" ];
      drivers = with pkgs; [ brlaser ];
    };
  };

}
