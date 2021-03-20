# My NixOS configuration

Configuration for home directory and a complete NixOS system. Machine configurations are in `hosts/`, split currently into two hosts:

- `muspus` has the ThinkPad T25 configuration. Intel system using Wayland/Sway.
- `naunau` has the Workstation configuration. AMD system with NVidia graphics card using Xorg/i3.

## New system installation

1. Use the unstable build of [NixOS 21.05](https://releases.nixos.org/?prefix=nixos/unstable/).
2. Boot into the installer.
3. `DISK=/dev/disk/by-id/... ./partition.sh`
4. Install these dotfiles:
5. `nix-shell -p git nixFlakes`
6. `git clone https://github.com/pimeys/nixos /tmp/nixos`
7. `nixos-generate-config --root /mnt --show-hardware-config`
8. Merge the hardware config with the dotfiles in `/mnt/etc/nixos`
7. Install NixOS: `nixos-install --root /mnt --flake /mnt/etc/nixos#XYZ`, where
   `XYZ` is [the host you want to install](hosts/).
8. Reboot!
9. Change your `root` and `$USER` passwords!

