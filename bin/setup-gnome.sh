#!/bin/bash

set -e

pacstrap /mnt gnome gnome-terminal gnome-tweaks gnome-notes

arch-chroot /mnt /bin/bash -c "systemctl enable gdm.service"
arch-chroot /mnt /bin/bash -c "systemctl enable NetworkManager.service"
arch-chroot /mnt /bin/bash -c "systemctl enable bluetooth.service"
