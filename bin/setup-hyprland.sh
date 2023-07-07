#!/bin/bash

set -e

pacstrap /mnt hyprland networkmanager bluez sddm kitty dohphin qt5-wayland qt6-wayland wofi wl-clipboard wf-recorder falkon noto-fonts-cjk noto-fonts-emoji noto-fonts-extra noto-fonts

arch-chroot /mnt /bin/bash -c "systemctl enable sddm.service"
arch-chroot /mnt /bin/bash -c "systemctl enable NetworkManager.service"
arch-chroot /mnt /bin/bash -c "systemctl enable bluetooth.service"

cp ./customs/wayland.sh /mnt/etc/profile.d/wayland.sh
cp ./customs/xdg-open /mnt/usr/local/bin/xdg-open

mkdir -p /mnt/etc/sddm.conf.d
echo '[General]
DisplayServer=wayland' > /mnt/etc/sddm.conf.d/wayland.conf
