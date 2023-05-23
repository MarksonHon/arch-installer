#!/bin/bash

RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
RESET=$(tput sgr0)

ask_root_mountpoint(){
    echo "$GREEN""Now you should choose a partition as your root patition,""$RESET"
    if [ -d /sys/firmware/efi/efivars ];then
        echo "$BLUE""You have boot in UEFI mode, so choose a patition in a GPT device.""$RESET"
    else
        echo "$BLUE""You have boot in BIOS mode or UEFI/CSM mode, so choose a patition in a MBR device, and make sure the partition you chosen is marked as boot.""$RESET"
    fi
    echo "$GREEN""You can choose one of these partitions as yout root partition:""$RESET"
    echo "$(lsblk -nr | awk '{print $1}')"
    echo "$YELLOW""Type in your root partition(eg: sda1), you don't need to type in /dev/.""$RESET"
    read -p "$YELLOW""Input your root partition: ""$RESET" -r "ROOT_PARTITION"
}

choose_root_mountpoint(){
    disks_on_machine=$(lsblk -nr | awk '{print $1}')
    check_the_root_partition=$(echo "$disks_on_machine" | grep "$ROOT_PARTITION")
    while [ -z "$check_the_root_partition" ]; do
        echo "$YELLOW""The root partition you typed in is not available!""$RESET"
        ask_root_mountpoint
    done
    ROOT_PARTITION="/dev/""$ROOT_PARTITION"
}

ask_esp_mountpoint(){
    echo "$YELLOW""You should choose a partition as your EFI patition:""$RESET"
    echo "$YELLOW""Type in your EFI partition(eg: sda1), you don't need to type in /dev/.""$RESET"
    read -p "$YELLOW""Input your EFI partition: ""$RESET" -r "ESP"
}

choose_esp_mountpoint(){
    disks_on_machine=$(lsblk -nr | awk '{print $1}')
    check_the_efi_partition=$(echo "$disks_on_machine" | grep "$ESP")
    while [ -z "$check_the_efi_partition" ]; do
        echo "$YELLOW""The root partition you typed in is not available!""$RESET"
        ask_root_mountpoint
    done
    ESP="/dev/""$ESP"
}

ask_grub_bios(){
    echo "$YELLOW""Input the device (NOT a partition) that grub bootloader will be install:""$RESET"
    echo "$(lsblk -nr | awk '{print $1}')"
    read -p "$YELLOW""Input the device:""$RESET" -r "DEVICE"
}

choose_grub_bios(){
    disks_on_machine=$(lsblk -nr | awk '{print $1}')
    check_the_bios_device=$(echo "$disks_on_machine" | grep "$DEVICE")
    while [ -z "$check_the_bios_device" ]; do
        echo "$YELLOW""The device you typed in is not available!""$RESET"
        ask_grub_bios
    done
    DEVICE="/dev/""$DEVICE"
}

mount_mountpoints(){
    ask_root_mountpoint
    choose_root_mountpoint
    if [ -d /sys/firmware/efi/efivars ];then
        ask_esp_mountpoint
        choose_esp_mountpoint
    else
        ask_grub_bios
        choose_grub_bios
    fi
    read -p "$YELLOW""Input yes to format root if you want:""$RESET" -r "FORMAT_ROOT"
    if [ "$FORMAT_ROOT" == "yes" ]; then
        mkfs.ext4 "$ROOT_PARTITION"
    fi
    if [ -n "$ESP" ]; then
        read -p "$YELLOW""Input yes to format ESP if you want:""$RESET" -r "FORMAT_ESP"
        if [ "$FORMAT_ESP" == "yes" ];then
            mkfs.vfat "$ESP"
        fi
    fi
}

ask_desktop(){
    echo "$GREEN""You can choose one of these desktops:""$RESET"
    echo "1. GNOME"
    echo "2. KDE Plasma"
    echo "3. Deepin"
    echo "4. Xfce Desktop"
    echo "5. Hyprland"
    echo "6. No desktop(CLI only)"
    echo "$YELLOW""Which desktop do you want to use?""$RESET"
    read -p "$YELLOW""Input your choice number: ""$RESET" -r "DESKTOP_CHOOSEN"
}

choose_desktop(){
    while [ -z "$desktop_name" ]
    do
        if [ "$DESKTOP_CHOOSEN" == '1' ];then
            desktop_installer="./bin/setup-gnome.sh"
            desktop_name="Gnome Shell"
        elif [ "$DESKTOP_CHOOSEN" == '2' ];then
            desktop_installer="./bin/setup-plasma.sh"
            desktop_name="KDE Plasma"
        elif [ "$DESKTOP_CHOOSEN" == '3' ];then
            desktop_installer="./bin/setup-deepin.sh"
            desktop_name="Deepin Desktop"
        elif [ "$DESKTOP_CHOOSEN" == '4' ];then
            desktop_installer="./bin/setup-xfce.sh"
            desktop_name="Xfce Desktop"
        elif [ "$DESKTOP_CHOOSEN" == '5' ];then
            desktop_installer="./bin/setup-hyprland.sh"
            desktop_name="Hyprland Wayland WM"
        elif [ "$DESKTOP_CHOOSEN" == '6' ];then
            echo "$YELLOW""No desktop would be installed""$RESET"
            desktop_name="none"
        else
            echo "$YELLOW""You must make a choice!""$RESET"
            desktop_name=""
            ask_desktop
        fi
    done
}

install_desktop(){
    if ! /bin/bash -c "$desktop_installer";then
        echo "$RED""Failed to install $desktop_name!""$RESET"
        exit 1
    fi
}


ask_kernel(){
    echo "$GREEN""You can choose one of these Linux kernels:""$RESET"
    echo "1. Linux Kernel(the default kernel)(linux)"
    echo "2. Linux LTS Kernel(linux-lts)"
    echo "3. Linux Zen Kernel(linux-zen)"
    echo "4. Linux Hardened Kernel(linux-hardened)"
    echo "5. Linux Realtime Kernel(linux-rt)"
    echo "6. Linux Realtime LTS Kernel(linux-rt-lts)"
    echo "$YELLOW""Which Linux kernel do you want to use?""$RESET"
    read -p "$YELLOW""Input your choice number: ""$RESET" -r "KERNEL_CHOOSEN"
}

choose_kernel(){
    while [ -z "$kernel_name" ]
    do
        if [ "$KERNEL_CHOOSEN" == '1' ];then
            kernel_to_install="linux"
            kernel_name="Linux Kernel(the default kernel)"
        elif [ "$KERNEL_CHOOSEN" == '2' ];then
            kernel_to_install="linux-lts"
            kernel_name="Linux LTS Kernel"
        elif [ "$KERNEL_CHOOSEN" == '3' ];then
            kernel_to_install="linux-zen"
            kernel_name="Linux Zen Kernel"
        elif [ "$KERNEL_CHOOSEN" == '4' ];then
            kernel_to_install="linux-hardened"
            kernel_name="Linux Hardened Kernel"
        elif [ "$KERNEL_CHOOSEN" == '5' ];then
            kernel_to_install="linux-rt"
            kernel_name="Linux Realtime Kernel"
        elif [ "$KERNEL_CHOOSEN" == '6' ];then
            kernel_to_install="linux-rt-lts"
            kernel_name=" Linux Realtime LTS Kernel"
        else
            echo "$YELLOW""You must make a choice!""$RESET"
            kernel_name=""
            ask_kernel
        fi
    done
}

uefi_ask_bootloader(){
    echo "$GREEN""You can choose one of bootloaders:""$RESET"
    echo "1. Grub"
    echo "2. Systemd boot"
    echo "$YELLOW""Which bootloader do you want to use?""$RESET"
    read -p "$YELLOW""Input your choice number: ""$RESET" -r "BOOTLOADER_CHOOSEN"
}

uefi_choose_bootloader(){
    while [ -z "$bootloader_installer" ]
    do
        if [ "$BOOTLOADER_CHOOSEN" == '1' ];then
            bootloader_installer="./bin/install-grub-uefi.sh"
        elif [ "$BOOTLOADER_CHOOSEN" == '2' ];then
            bootloader_installer="./bin/install-systemd-boot.sh"
        else
            echo "$YELLOW""You must make a choice!""$RESET"
            uefi_ask_bootloader
        fi
    done
}

ask_bootloader(){
    if [ -d /sys/firmware/efi/efivars ];then
        uefi_ask_bootloader
        uefi_choose_bootloader
    else
        bootloader_installer="./bin/install-grub-bios.sh"
    fi
}

install_bases(){
    pacstrap /mnt base base-devel linux-firmware dnsutils usbutils
    genfstab -U /mnt | tee /mnt/etc/fstab
    /bin/bash -c "$bootloader_installer"
}

main(){
    ask_kernel
    choose_kernel
    mount_mountpoints
    ask_desktop
    choose_desktop
    ask_bootloader
}