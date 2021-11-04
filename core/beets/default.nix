{ lib, home-manager, pkgs, ... }: {
  home-manager.users.pimeys.programs.beets = {
    enable = true;
    settings = {
      directory = "/mnt/music";
      library = "/home/pimeys/.config/beets/musiclibrary.blb";
      plugins = "convert replaygain fetchart";
      replaygain = { backend = "gstreamer"; };
      import = { move = true; };
      fetchart = { auto = true; };
      convert = {
        auto = false;
        threads = 4;
        copy_album_art = true;
        embed = true;
        format = "opus";
        dest = "/mnt/opus/";
        formats = {
          opus = {
            command = "ffmpeg -i $source -ar 48000 -ac 2 -ab 96k $dest";
            extension = "opus";
          };
        };
      };
    };
  };
}
