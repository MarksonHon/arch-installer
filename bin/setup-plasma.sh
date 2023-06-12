#!/bin/bash

set -e

pacstrap /mnt plasma-meta plasma-wayland-session falkon vlc pipewire-pulse pipewire-jack plasma ksystemlog kcolorchooser colord-kde gwenview dolphin kcalc spectacle konsole noto-fonts-cjk noto-fonts-emoji noto-fonts-extra noto-fonts

arch-chroot /mnt /bin/bash -c "systemctl enable sddm.service"
arch-chroot /mnt /bin/bash -c "systemctl enable NetworkManager.service"
arch-chroot /mnt /bin/bash -c "systemctl enable bluetooth.service"
