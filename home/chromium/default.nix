{ pkgs, lib, ... }:

{
  xdg.desktopEntries.chromium = {
    name = "Ungoogled Chromium";
    genericName = "Web Browser";
    exec = ''
      chromium \
                --enable-features=UseOzonePlatform,VaapiVideoDecoder \
                --ozone-platform=wayland \
                --ignore-gpu-blocklist \
                --enable-gpu-rasterization \
                --disable-gpu-driver-bug-workarounds \
                --enable-accelerated-video-decode \
                --use-gl=desktop \
                --enable-zero-copy'';
    terminal = false;
    categories = [ "Application" ];
  };

  programs.chromium = {
    enable = true;
    package = pkgs.master.ungoogled-chromium;
    extensions = let
      createChromiumExtensionFor = browserVersion:
        { id, sha256, version }: {
          inherit id;
          crxPath = builtins.fetchurl {
            url =
              "https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx2,crx3&prodversion=${browserVersion}&x=id%3D${id}%26installsource%3Dondemand%26uc";
            name = "${id}.crx";
            inherit sha256;
          };
          inherit version;
        };
      createChromiumExtension = createChromiumExtensionFor
        (lib.versions.major pkgs.ungoogled-chromium.version);
    in [
      (createChromiumExtension {
        # nord theme
        id = "cnfjnjfppmpabbbdeijhimfijipmmanj";
        sha256 = "sha256:1xl4ka95lsisdzfciiwizr4bfsxz9vs0hnfimmm5scpykvnm3m4k";
        version = "1.0";
      })
      (createChromiumExtension {
        # ublock origin
        id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";
        sha256 = "sha256:12ps948lg91bbjxjmwb3d8590q8rf4mv7bkhzrjnnd210gbl5wxn";
        version = "1.38.6";
      })
      (createChromiumExtension {
        # decentraleyes
        id = "ldpochfccmkkmhdbclfhpagapcfdljkj";
        sha256 = "sha256:0cmkc01z06sw8rarsy9w1v6lpw2r39ad14m7b80bcgmfbxbh0ind";
        version = "2.0.16";
      })
      (createChromiumExtension {
        # zoom redirector
        id = "fmaeeiocbalinknpdkjjfogehkdcbkcd";
        sha256 = "sha256:0lmdamqm1p4sh454bha3f9h49q0gnig1yr6qm5z1rzlsivmwhfbn";
        version = "1.0.2";
      })
      (createChromiumExtension {
        # clearurls
        id = "lckanjgmijmafbedllaakclkaicjfmnk";
        sha256 = "sha256:004skr65b7jljm6w4znpgp7ys8h2cvbald73k5lgajrci92yz7f9";
        version = "1.21.0";
      })
    ];
  };
}
