# ryudots

dotfiles for Hyprland setup.

### Installing Limine (My new favorite)

Install the package first, called `limine` in Arch repo and follow the following steps.

```zsh
sudo pacman -S limine
```
This will install limine. If you have an UEFI system you just need to create a boot entry and configure limine like this.

#### Creating Boot Entry
```zsh
# efibootmgr \
      --create \
      --disk /dev/sdX \
      --part Y \
      --label "Arch Linux Limine Bootloader" \
      --loader '\EFI\limine\BOOTX64.EFI' \
      --unicode
```
`/dev/sdX` is _**YOUR**_ drive and `Y` is partition number.

#### Configuring Limine
```zsh
timeout: 5

/Arch Linux (linux-cachyos)
    protocol: linux
    path boot():/vmlinuz-linux-cachyos
    cmdline: cryptdevice=PARTUUID=83af52d9-dd66-4821-9797-fb17f78d7b94:main root=/dev/sapper/main zswap.enabled=0 rootflags=subvol=@ rw rootfstype=btrfs
    module_path: boot():/initramfs-linux-cachyos.img

/Arch Linux (linux-cachyos-fallback)
    protocol: linux
    path: boot():/vmlinuz-linux-cachyos
    cmdline: cryptdevice=PARTUUID=83af52d9-dd66-4821-9797-fb17478d7b94:main root=/dev/mapper/main zswap.enabled=0 rootflags=subvol=@ rw rootfstype=btrfs
    module_path: boot():/initramfs-linux-cachyos-fallback.img
```
You can add and other customizations at a later date.

### To install zram

Run the script in the `Scripts` folder called [install-zram.sh](./Scripts/install-zram.sh).

> If it gets stuck `ctrl-C` and restart your pc and it should be okay.
