#!/bin/bash

set -e

pacstrap /mnt plasma-meta plasma-wayland-session falkon vlc pipewire-pulse pipewire-jack plasma ksystemlog kcolorchooser colord-kde gwenview dolphin kcalc spectacle konsole

systemctl enable sddm.service
systemctl enable NetworkManager.service
systemctl enable bluetooth.service