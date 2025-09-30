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
    cmdline: cryptdevice=PARTUUID=XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX:main root=/dev/sapper/main zswap.enabled=0 rootflags=subvol=@ rw rootfstype=btrfs
    module_path: boot():/initramfs-linux-cachyos.img

/Arch Linux (linux-cachyos-fallback)
    protocol: linux
    path: boot():/vmlinuz-linux-cachyos
    cmdline: cryptdevice=PARTUUID=XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX:main root=/dev/mapper/main zswap.enabled=0 rootflags=subvol=@ rw rootfstype=btrfs
    module_path: boot():/initramfs-linux-cachyos-fallback.img
```
You can add and other customizations at a later date. `XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX` means PARTUUID of the encrypted partition when using `blkid`. 
Now customizing the limine bootloader.
```zsh
timeout: 5
default_entry: 2
remember_last_entry: yes

# CachyOS Limine theme
# Author: diegons490 (https://github.com/diegons490/cachyos-limine-theme)
term_palette: 1e1e2e;f38ba8;a6e3a1;f9e2af;89b4fa;f5c2e7;94e2d5;cdd6f4
term_palette_bright: 585b70;f38ba8;a6e3a1;f9e2af;89b4fa;f5c2e7;94e2d5;cdd6f4
term_background: ffffffff
term_foreground: cdd6f4
term_background_bright: ffffffff
term_foreground_bright: cdd6f4
interface_branding:
wallpaper: boot():/limine-splash.png

/+CachyOS
  //linux-cachyos
  comment: 6.16.8-2-cachyos
  protocol: linux
  module_path: boot():/92db65653f7b4ab5a73ca4e0a6e85879/linux-cachyos/initramfs-linux-cachyos#<sha256-hash>
  kernel_path: boot():/92db65653f7b4ab5a73ca4e0a6e85879/linux-cachyos/vmlinuz-linux-cachyos#<sha256-hash>
  kernel_cmdline: quiet nowatchdog splash rw rootflags=subvol=/@ cryptdevice=UUID=<uuid-of-partition>:main root=/dev/mapper/main

  //linux-cachyos-lts
  comment: 6.12.48-2-cachyos-lts
  protocol: linux
  module_path: boot():/92db65653f7b4ab5a73ca4e0a6e85879/linux-cachyos-lts/initramfs-linux-cachyos-lts#<sha256-hash>
  kernel_path: boot():/92db65653f7b4ab5a73ca4e0a6e85879/linux-cachyos-lts/vmlinuz-linux-cachyos-lts#<sha256-hash>
  kernel_cmdline: quiet nowatchdog splash rw rootflags=subvol=/@ cryptdevice=UUID=<uuid-of-partition>:main root=/dev/mapper/main
```
This is the cachyos default limine setup.
