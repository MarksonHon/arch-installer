#!/bin/bash

set -e

pacstrap /mnt hyprland networkmanager bluez ly kitty dohphin qt5ct qt5-wayland qt6-wayland wofi wl-clipboard wf-recorder falkon noto-fonts-cjk noto-fonts-emoji noto-fonts-extra noto-fonts

arch-chroot /mnt /bin/bash -c "systemctl enable ly.service"
arch-chroot /mnt /bin/bash -c "systemctl enable NetworkManager.service"
arch-chroot /mnt /bin/bash -c "systemctl enable bluetooth.service"

cp ./customs/wayland.sh /mnt/etc/profile.d/wayland.sh
cp ./customs/xdg-open /mnt/usr/local/bin/xdg-open

