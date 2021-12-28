# My NixOS configuration

Configuration for home directory and a complete NixOS system. Machine configurations are in `hosts/`, split currently into two hosts:

- `naunau` has the home workstation configuration. AMD Ryzen 3950x system with a Radeon graphics card.
- `meowmeow` has the ThinkPad X230 configuration. Intel system.
- `muspus` has the ThinkPad T25 configuration. Intel system.
- `purrpurr` has the ThinkPad X1 Carbon configuration. Intel system.
- `munchmunch` has the office workstation configuration. AMD ThreadRipper 2970wx system with a Radeon graphics card.

## Notable files for reading

If looking for help and examples how to do things in Nix, or having any questions or suggestions, please file an issue and I can try to help when having some time. This setup has been my learning process for the Nix language and ecosystem, and is still changing when I find out how to do things better.

There are a few things here that I would've found interesting and helpful when jumping in to Nix:

- A reproducible [Emacs configuration](desktop/emacs/config.org) with Wayland and native compilation support, elisp packages from Nix.
- A reproducible [NeoVim configuration](core/nvim) using Nix as the source for libraries.
- [Firefox configuration](desktop/firefox/default.nix) which takes addons from Nix and sets as many settings as possible from Nix.
- [Wayland screen sharing and streaming](desktop/video-streaming/default.nix) using OBS Studio and a video4linux loopback device to work with Zoom being a garbage piece of software.
- Tiling Wayland compositor [Sway setup](desktop/sway/default.nix).
- Setup for perfect Linux sound and all the Bluetooth codecs using [Pipewire and Bluez](desktop/pipewire/default.nix).
- Reproducible [Cups setup](core/home-services.nix#L13-L39) to have our home printer always working without touching the Cups admin.

## New system installation

1. Use the unstable build of [NixOS 21.05](https://releases.nixos.org/?prefix=nixos/unstable/).
1. Boot into the installer.
1. `git clone https://github.com/pimeys/nixos /tmp/nixos`
1. `cd /tmp/nixos && git submodule update`
1. `DISK=/dev/disk/by-id/... ./partition.sh`
1. `mv /tmp/nixos /mnt/etc/nixos`
1. `nixos-generate-config --root /mnt --show-hardware-config`
1. Add output of the previous file to a new config in `hosts`
1. Add the new host to `flake.nix`
1. `nix-shell -p git nixFlakes`
1. Merge the hardware config with the dotfiles in `/mnt/etc/nixos`
1. Install NixOS: `nixos-install --root /mnt --flake /mnt/etc/nixos#XYZ`, where
   `XYZ` is [the host you want to install](hosts/).
1. Reboot!
1. Change your `root` and `$USER` passwords!
1. `chmod -R pimeys:users /etc/nixos`
1. `ln -s /etc/nixos /home/pimeys/.config/nixpkgs`
