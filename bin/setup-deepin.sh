#!/bin/bash

set -e

pacstrap /mnt deepin deepin-extra falkon

arch-chroot /mnt /bin/bash -c "systemctl enable lightdm.service"
arch-chroot /mnt /bin/bash -c "systemctl enable NetworkManager.service"
arch-chroot /mnt /bin/bash -c "systemctl enable bluetooth.service"
