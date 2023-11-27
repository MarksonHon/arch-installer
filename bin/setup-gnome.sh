#!/bin/bash

set -e

pacstrap /mnt gnome gnome-terminal gnome-tweaks gnome-notes noto-fonts-cjk noto-fonts-emoji noto-fonts-extra noto-fonts networkmanager

arch-chroot /mnt /bin/bash -c "systemctl enable gdm.service"
arch-chroot /mnt /bin/bash -c "systemctl enable NetworkManager.service"
arch-chroot /mnt /bin/bash -c "systemctl enable bluetooth.service"

cp ./customs/wayland.sh /mnt/etc/profile.d/wayland.sh
cp ./customs/xdg-open /mnt/usr/local/bin/xdg-open