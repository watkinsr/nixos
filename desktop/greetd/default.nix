{ pkgs, ... }:

{
  services.greetd = {
    enable = true;
    vt = 7;
    settings.default_session = with pkgs; {
      command = "${cage}/bin/cage ${greetd.gtkgreet}/bin/gtkgreet";
    };
  };

  environment.etc = {
    "greetd/environments".text = ''
      sway
    '';
  };
}
