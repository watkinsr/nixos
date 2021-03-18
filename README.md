# My NixOS configuration

Configuration for home directory and a complete NixOS system. Machine configurations are in `hosts/`, split currently into two hosts:

- `muspus` has the ThinkPad T25 configuration. Intel system using Wayland/Sway.
- `naunau` has the Workstation configuration. AMD system with NVidia graphics card using Xorg/i3.

## New system installation

1. Use the unstable build of [NixOS 21.05](https://releases.nixos.org/?prefix=nixos/unstable/).
2. Boot into the installer.
3. Partition your disk ([see partitioning](#partitioning))
4. Install these dotfiles:
5. `nix-shell -p git nixFlakes`
6. `git clone https://github.com/pimeys/nixos /tmp/nixos`
7. `nixos-generate-config --root /mnt --show-hardware-config`
8. Merge the hardware config with the dotfiles in `/mnt/etc/nixos`
7. Install NixOS: `nixos-install --root /mnt --flake /mnt/etc/nixos#XYZ`, where
   `XYZ` is [the host you want to install](hosts/).
8. Reboot!
9. Change your `root` and `$USER` passwords!

## Partitioning

``` sh
# Always use the by-id aliases for devices, otherwise ZFS can choke on imports.
DISK=/dev/disk/by-id/...
https://releases.nixos.org/?prefix=nixos/unstable/
# Partition 2 will be the boot partition, needed for legacy (BIOS) boot
sgdisk -a1 -n2:34:2047 -t2:EF02 $DISK
# If you need EFI support, make an EFI partition:
sgdisk -n3:1M:+512M -t3:EF00 $DISK
# Partition 1 will be the main ZFS partition, using up the remaining space on the drive.
sgdisk -n1:0:0 -t1:BF01 $DISK

zpool create -O mountpoint=none -O atime=off -O compression=lz4 -O xattr=sa -O acltype=posixacl -o ashift=12 encryption=aes-256-gcm -O keyformat=passphrase rpool $DISK-part1

# Create the filesystems. This layout is designed so that /home is separate from the root
# filesystem, as you'll likely want to snapshot it differently for backup purposes. It also
# makes a "nixos" filesystem underneath the root, to support installing multiple OSes if
# that's something you choose to do in future.
zfs create -o mountpoint=legacy rpool/root
zfs create -o mountpoint=legacy rpool/root/nixos
zfs create -o mountpoint=legacy rpool/home

# Mount the filesystems manually. The nixos installer will detect these mountpoints
# and save them to /mnt/nixos/hardware-configuration.nix during the install process.
mount -t zfs rpool/root/nixos /mnt
mkdir /mnt/home
mount -t zfs rpool/home /mnt/home

# If you need to boot EFI, you'll need to set up /boot as a non-ZFS partition.
mkfs.vfat $DISK-part3
mkdir /mnt/boot
mount $DISK-part3 /mnt/boot
```
