#!/usr/bin/env bash
set -e

sudo pacman -S zram-generator --noconfirm --needed

#-------------------------------------------------------------------------

echo '[zram0]
zram-size = min(ram / 2 + 512)
compression-algorithm = zstd' | sudo tee /etc/systemd/zram-generator.conf

# Create new device
sudo systemctl daemon-reload
sudo systemctl start /dev/zram0

echo "check with"
echo "swapon or zramctl or"
echo "with systemdsystemctl status systemd-zram-setup@zram0.service"
