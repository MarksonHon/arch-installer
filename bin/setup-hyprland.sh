#!/bin/bash

set -e

pacstrap /mnt hyprland networkmanager bluez sddm kitty qt5-wayland qt6-wayland rofi rofi-emoji wl-clipboard wf-recorder falkon noto-fonts-cjk noto-fonts-emoji noto-fonts-extra noto-fonts

arch-chroot /mnt /bin/bash -c "systemctl enable sddm.service"
arch-chroot /mnt /bin/bash -c "systemctl enable NetworkManager.service"
arch-chroot /mnt /bin/bash -c "systemctl enable bluetooth.service"

cp ./customs/wayland.sh /mnt/etc/profile.d/wayland.sh
cp ./customs/xdg-open /mnt/usr/local/bin/xdg-open

echo '[General]
DisplayServer=wayland' > /mnt/etc/sddm.conf.d/wayland.conf