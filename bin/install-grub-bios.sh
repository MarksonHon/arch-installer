#!/bin/bash

pacstrap /mnt grub os-prober
arch-chroot /mnt /bin/bash -c "grub-install --target=i386-pc $DEVICE"
pacstrap /mnt mkinitcpio "$kernel_to_install" "$kernel_to_install""-headers"
arch-chroot /mnt /bin/bash -c "grub-mkconfig -o /boot/grub/grub.cfg"
