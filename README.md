# My NixOS configuration

Configuration for home directory and a complete NixOS system. Machine configurations are in `hosts/`, split currently into two hosts:

- `muspus` has the ThinkPad T25 configuration. Intel system using Wayland/Sway.
- `naunau` has the Workstation configuration. AMD system with NVidia graphics card using Xorg/i3.

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
1. `ln -s /etc/nixos /home/pimeys/.confit/nixpkgs`
