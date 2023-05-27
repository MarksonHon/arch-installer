#!/bin/bash

set -e

pacstrap /mnt hyprland networkmanager sddm kitty qt5-wayland qt6-wayland rofi rofi-emoji wl-clipboard wf-recorder falkon

arch-chroot /mnt /bin/bash -c "systemctl enable sddm.service"
arch-chroot /mnt /bin/bash -c "systemctl enable NetworkManager.service"
arch-chroot /mnt /bin/bash -c "systemctl enable bluetooth.service"
