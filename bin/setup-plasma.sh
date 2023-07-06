#!/bin/bash

set -e

pacstrap /mnt plasma-meta kde-system-meta kde-graphics-meta kde-utilities-meta plasma-wayland-session falkon pipewire-pulse pipewire-jack noto-fonts-cjk noto-fonts-emoji noto-fonts-extra noto-fonts

arch-chroot /mnt /bin/bash -c "systemctl enable sddm.service"
arch-chroot /mnt /bin/bash -c "systemctl enable NetworkManager.service"
arch-chroot /mnt /bin/bash -c "systemctl enable bluetooth.service"

cp ./customs/wayland.sh /mnt/etc/profile.d/wayland.sh