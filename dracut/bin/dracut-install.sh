#!/usr/bin/env bash

args=('--force' '--no-hostonly-cmdline')
ESP_PATH=$(bootctl --print-esp-path)

while read -r line; do
        if [[ "$line" == 'usr/lib/modules/'+([^/])'/pkgbase' ]]; then
                read -r pkgbase < "/${line}"
                kver="${line#'usr/lib/modules/'}"
                kver="${kver%'/pkgbase'}"
                install -Dm0644 "/${line%'/pkgbase'}/vmlinuz" "/boot/vmlinuz-${pkgbase}"
                echo "Generating unified kernel image for kernel version $kver to $ESP_PATH/EFI/Linux/arch-${pkgbase}.efi"
                dracut "${args[@]}" --hostonly --uefi "$ESP_PATH"/EFI/Linux/arch-${pkgbase}.efi --kver "$kver" > /dev/null 2>&1
                echo "Generating unified kernel image fallback for kernel version $kver to $ESP_PATH/EFI/Linux/arch-${pkgbase}-fallback.efi"
                dracut "${args[@]}" --no-hostonly --uefi "$ESP_PATH"/EFI/Linux/arch-${pkgbase}-fallback.efi --kver "$kver" > /dev/null 2>&1
        fi
done

