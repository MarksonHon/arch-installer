#!/bin/bash

arch-chroot /mnt /bin/bash -c "bootctl install --esp-path=/efi"
root_partition_part_uuid=$(lsblk "$ROOT_PARTITION" -no PARTUUID)
echo "root=PARTUUID=$root_partition_part_uuid rw rootfstype=ext4" > /mnt/etc/kernel/cmdline
mkdir -p /mnt/etc/mkinitcpio.d/
cat "./customs/systemd-boot-uki-kernel.conf" | sed "s|linux|$kernel_to_install|g" | tee "/mnt/etc/mkinitcpio.d/""$kernel_to_install"".preset.pacsave"
pacstrap /mnt mkinitcpio "$kernel_to_install" "$kernel_to_install""-headers"
