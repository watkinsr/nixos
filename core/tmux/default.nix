{ lib, home-manager, pkgs, ... }: {
  home-manager.users.ryan.programs.tmux = {
    enable = true;
    clock24 = true;
    extraConfig = ''
      set -ga terminal-overrides ',xterm-256color:Tc'
    '';
    plugins = with pkgs.tmuxPlugins; [{
      plugin = tmux-colors-solarized;
      extraConfig = ''
        set -g @colors-solarized 'dark' 
      '';
    }];
  };
}
