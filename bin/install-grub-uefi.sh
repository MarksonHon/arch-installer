#!/bin/bash

pacstrap /mnt grub efibootmgr os-prober
arch-chroot /mnt /bin/bash -c "grub-install --target=x86_64-efi --bootloader-id='Arch Linux' --efi-directory=$ESP"
pacstrap /mnt mkinitcpio "$kernel_to_install" "$kernel_to_install""-headers"
arch-chroot /mnt /bin/bash -c "grub-mkconfig -o /boot/grub/grub.cfg"
