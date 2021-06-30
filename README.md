# My NixOS configuration

Configuration for home directory and a complete NixOS system. Machine configurations are in `hosts/`, split currently into two hosts:

- `naunau` has the home workstation configuration. AMD Ryzen 3950x system with a Radeon graphics card.
- `meowmeow` has the ThinkPad X230 configuration. Intel system.
- `muspus` has the ThinkPad T25 configuration. Intel system.
- `purrpurr` has the ThinkPad X1 Carbon configuration. Intel system.
- `munchmunch` has the office workstation configuration. AMD ThreadRipper 2970wx system with a Radeon graphics card.

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
