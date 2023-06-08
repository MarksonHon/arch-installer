#!/bin/bash

set -e

pacstrap /mnt lightdm xfce4 xfce4-goodies falkon bluez

arch-chroot /mnt /bin/bash -c "systemctl enable lightdm.service"
arch-chroot /mnt /bin/bash -c "systemctl enable NetworkManager.service"
arch-chroot /mnt /bin/bash -c "systemctl enable bluetooth.service"
