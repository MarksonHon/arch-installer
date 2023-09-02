#!/usr/bin/env bash

ESP_PATH=$(bootctl --print-esp-path)

while read -r line; do
        if [[ "$line" == 'usr/lib/modules/'+([^/])'/pkgbase' ]]; then
                read -r pkgbase < "/${line}"
                rm -f "/boot/vmlinuz-${pkgbase}" "$ESP_PATH"/EFI/Linux/arch-${pkgbase}.efi "$ESP_PATH"/EFI/Linux/arch-${pkgbase}-fallback.efi 
        fi
done