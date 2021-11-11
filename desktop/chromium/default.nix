{ pkgs, lib, ... }:

{
  home-manager.users.ryan = {
    programs.chromium = {
      enable = true;
      package = (pkgs.ungoogled-chromium.override {
        commandLineArgs = [
          "--enable-features=UseOzonePlatform,VaapiVideoDecoder"
          "--ozone-platform=wayland"
          "--ignore-gpu-blocklist"
          "--enable-gpu-rasterization"
          "--disable-gpu-driver-bug-workarounds"
          "--disable-background-networking"
          "--disable-reading-from-canvas"
          "--enable-accelerated-video-decode"
          "--use-gl=desktop"
          "--enable-zero-copy"
        ];
      });
    };
  };
}
