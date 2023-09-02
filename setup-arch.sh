#!/bin/bash

RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BROWN=$(tput setaf 5)
RESET=$(tput sgr0)

choose_ucode(){
    if [ -n "$(cat /proc/cpuinfo | grep Intel)" ];then
        ucode="intel-ucode"
    elif [ -n "$(cat /proc/cpuinfo | grep AMD)" ];then
        ucode="amd-ucode"
    fi
}

ask_root_mountpoint(){
    echo "$GREEN""Now you should choose a partition as your root patition,""$RESET"
    if [ -d /sys/firmware/efi/efivars ];then
        echo "$BROWN""You have boot in UEFI mode, so choose a patition in a GPT device.""$RESET"
    else
        echo "$BROWN""You have boot in BIOS mode or UEFI/CSM mode, so choose a patition in a MBR device, and make sure the partition you chosen is marked as boot.""$RESET"
    fi
    echo "$YELLOW""Type in your root partition(eg: sda1), you don't need to type in /dev/.""$RESET"
    read -p "$YELLOW""Input your root partition: ""$RESET" -r "ROOT_PARTITION"
}

choose_root_mountpoint(){
    while ! [ -b /dev/"$ROOT_PARTITION" ]; do
        echo "$RED""The root partition you typed in is not available!""$RESET"
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
    while ! [ -b /dev/"$ESP" ]; do
        echo "$RED""The EFI partition you typed in is not available!""$RESET"
        ask_esp_mountpoint
    done
    ESP="/dev/""$ESP"
}

ask_other_mountpoints(){
    echo "$YELLOW""You can choose other partitions as your mountpoints, leave it black if you don't need other partition.""$RESET"
    echo "$YELLOW""Type in your partition(eg: sda1), you don't need to type in /dev/.""$RESET"
    read -p "$YELLOW""Input your partition: ""$RESET" -r "PARTITION_OTHER"
    if [ -n "$PARTITION_OTHER" ];then
        echo "$YELLOW""Type in your mountpoint(eg: /boot, /var), you don't need to type in /mnt.""$RESET"
        read -p "$YELLOW""Input your mountpoint: ""$RESET" -r "MOUNTPOINT_OTHER"
    fi
}

mount_other_mountpoints(){
    ask_other_mountpoints
    while [ -n "$PARTITION_OTHER" ]; do
        if [ -b /dev/"$PARTITION_OTHER" ];then
            mkdir -p /mnt"$MOUNTPOINT_OTHER"
            read -p "$YELLOW""Input yes to format the partition if you want:""$RESET" -r "FORMAT_OTHER"
            if [ "$FORMAT_OTHER" == "yes" ];then
                mkfs.ext4 /dev/"$PARTITION_OTHER"
            fi
            mount /dev/"$PARTITION_OTHER" /mnt"$MOUNTPOINT_OTHER"
        else
            echo "$RED""The partition you typed in is not available!""$RESET"
        fi
    ask_other_mountpoints
    done
}

ask_grub_bios(){
    echo "$YELLOW""Input the device (NOT a partition) that grub bootloader will be install:""$RESET"
    read -p "$YELLOW""Input the device:""$RESET" -r "DEVICE"
}

choose_grub_bios(){
    while ! [ -b /dev/"$DEVICE" ]; do
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
    mount "$ROOT_PARTITION" /mnt
    if [ -n "$ESP" ]; then
        mkdir /mnt/efi
        mount "$ESP" /mnt/efi
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
    if [ -n "$desktop_installer" ];then
        while true; do
            if ! /bin/bash -c "$desktop_installer";then
                echo "$RED""Failed to install $desktop_name!""$RESET"
                echo "$YELLOW""Do you want to try again?""$RESET"
            else
                echo "$GREEN""$desktop_name installed successfully!""$RESET"
                break
            fi
            read -p "$YELLOW""Input yes / leave blank to try again, no to skip: ""$RESET" -r "TRY_AGAIN"
            if [ "$TRY_AGAIN" == "no" ];then
                break
            fi
        done
    fi
}


ask_kernel(){
    echo "$GREEN""You can choose one of these Linux kernels:""$RESET"
    echo "1. Linux Kernel (the default kernel)(linux)"
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
            kernel_name="Linux Realtime LTS Kernel"
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
            bootloader_installer="grub-uefi"
        elif [ "$BOOTLOADER_CHOOSEN" == '2' ];then
            bootloader_installer="systemd-boot"
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
        bootloader_installer="grub-bios"
    fi
}

install_bootloader(){
    if [ "$bootloader_installer" == 'grub-uefi' ];then
        install_grub_uefi
    elif [ "$bootloader_installer" == 'grub-bios' ];then
        install_grub_bios
    elif [ "$bootloader_installer" == 'systemd-boot' ];then
        install_systemd_boot
    fi
}

install_bases(){
    pacstrap -K /mnt base base-devel linux-firmware dnsutils usbutils libva-utils "$ucode" zsh unrar p7zip unzip sudo nano
    pacstrap /mnt libva-mesa-driver intel-media-driver libva-intel-driver vulkan-intel vulkan-radeon vulkan-mesa-layers
    genfstab -U /mnt | tee /mnt/etc/fstab
    echo 'include "/usr/share/nano/*.nanorc"
include "/usr/share/nano/extra/*.nanorc"' >> /mnt/etc/nanorc
}

ask_sudo_user(){
    while true; do
        echo "$YELLOW""Now you should add user with sudo access, an username should always be lowercase:""$RESET"
        read -p "$YELLOW""Input your username: ""$RESET" -r "USERNAME"
        check_username=$(grep -E "^$USERNAME" /etc/passwd)
        if echo "$USERNAME" | grep -q "^[a-z]*$"; then
            if [ -z "$check_username" ]; then
                echo "$GREEN""Your username is""$RESET ""$USERNAME"
                break
            else
                echo "$RED""Your username is already exist, or you have not input your username!""$RESET"
            fi
        else
            echo "$RED""Username should always be lowercase, input again!""$RESET"
        fi
    done
    while true; do
        read -p "$YELLOW""Input your password: ""$RESET" -s -r "PASSWORD"; printf "\n"
        read -p "$YELLOW""Input your password again: ""$RESET" -s -r "PASSWORD_AGAIN"; printf "\n"
        if [ "$PASSWORD" == "$PASSWORD_AGAIN" ]; then
            echo "$GREEN""Set password successfully""$RESET"
            break
        else
            echo "$RED""The password you input firstly is NOT match the password you input secondly!""$RESET"
        fi
    done
}

add_sudo_user(){
    arch-chroot /mnt /bin/bash -c "useradd -m -G wheel -s /bin/zsh $USERNAME"
    arch-chroot /mnt /bin/bash -c "echo $USERNAME:$PASSWORD | chpasswd"
    sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /mnt/etc/sudoers
}

ask_locale(){
    while true; do
        echo "$YELLOW""Input your locale, such as en_US, zh_CN or de_DE.""$RESET"
        read -p "$YELLOW""Input locale: ""$RESET" -r "USER_LOCALE"
        check_locale=$(cat /etc/locale.gen | grep "$USER_LOCALE")
        if [ -n "$check_locale" ]; then
            echo "$GREEN""Your locale is""$RESET ""$USER_LOCALE"
            break
        else
            echo "$RED""Your locale is invaild, input again!""$RESET"
        fi
    done
}

setup_locale(){
    real_locale=$(cat /mnt/etc/locale.gen | grep UTF-8 | grep "$USER_LOCALE" | sed 's|#||g')
    sed -i "s|#$real_locale|$real_locale|" /mnt/etc/locale.gen
    echo "LANG=$USER_LOCALE.UTF-8" >> /mnt/etc/locale.conf
    arch-chroot /mnt/ /bin/bash -c "locale-gen"
}

ask_timezone(){
    while true; do
        echo "$YELLOW""Input your timezone, such as Asia/Shanghai, America/New_York.""$RESET"
        read -p "$YELLOW""Input timezone: ""$RESET" -r "USER_TIMEZONE"
        if [ -f /usr/share/zoneinfo/"$USER_TIMEZONE" ];then
            echo "$GREEN""Your timezone is""$RESET ""$USER_TIMEZONE"
            break
        else
            echo "$RED""Your timezone is invaild, input again!""$RESET"
        fi
    done
}

setup_timezone(){
    arch-chroot /mnt/ /bin/bash -c "ln -sf /usr/share/zoneinfo/$USER_TIMEZONE /etc/localtime"
    arch-chroot /mnt/ /bin/bash -c "hwclock --systohc"
}

install_grub_bios(){
    pacstrap /mnt grub os-prober
    pacstrap /mnt mkinitcpio "$kernel_to_install" "$kernel_to_install""-headers"
    arch-chroot /mnt /bin/bash -c "grub-install --target=i386-pc $DEVICE"
    arch-chroot /mnt /bin/bash -c "echo 'GRUB_DISABLE_OS_PROBER=false' >> /etc/default/grub"
    arch-chroot /mnt /bin/bash -c "grub-mkconfig -o /boot/grub/grub.cfg"
}

install_grub_uefi(){
    pacstrap /mnt grub efibootmgr os-prober
    pacstrap /mnt mkinitcpio "$kernel_to_install" "$kernel_to_install""-headers"
    arch-chroot /mnt /bin/bash -c "grub-install --target=x86_64-efi --bootloader-id='Arch Linux' --efi-directory=/efi"
    arch-chroot /mnt /bin/bash -c "grub-install --target=x86_64-efi --bootloader-id='Arch Linux' --efi-directory=/efi --removable"
    arch-chroot /mnt /bin/bash -c "echo 'GRUB_DISABLE_OS_PROBER=false' >> /etc/default/grub"
    arch-chroot /mnt /bin/bash -c "grub-mkconfig -o /boot/grub/grub.cfg"
}

install_systemd_boot(){
    arch-chroot /mnt /bin/bash -c "bootctl install --esp-path=/efi"
    pacstrap /mnt dracut plymouth
    [ -d /etc/dracut.conf.d ] || mkdir /etc/dracut.conf.d
    root_partition_part_uuid="$(lsblk "$ROOT_PARTITION" -no PARTUUID)"
    echo "kernel_cmdline=""\"root=PARTUUID=$root_partition_part_uuid rw rootfstype=ext4 splash quiet\"" > /mnt/etc/dracut.conf.d/cmdline.conf 
    cp ./dracut/bin/dracut-install.sh /mnt/usr/local/bin/dracut-install.sh
    cp ./dracut/bin/dracut-remove.sh /mnt/usr/local/bin/dracut-remove.sh
    chmod +x /mnt/usr/local/bin/dracut-install.sh /mnt/usr/local/bin/dracut-remove.sh
    mkdir /mnt/etc/pacman.d/hooks
    cp ./dracut/hooks/dracut-install.hook /mnt/etc/pacman.d/hooks/60-dracut-install.hook
    cp ./dracut/hooks/dracut-remove.hook /mnt/etc/pacman.d/hooks/90-dracut-remove.hook
    [ -d /mnt/etc/plymouth/ ] || mkdir /mnt/etc/plymouth/
    echo '[Daemon]
Theme=bgrt' > /etc/plymouth/plymouthd.conf
    pacstrap /mnt "$kernel_to_install" "$kernel_to_install""-headers"
}

enable_timesync(){
    arch-chroot /mnt /bin/bash -c "systemctl enable systemd-timesyncd.service"
}

main(){
    choose_ucode
    ask_kernel
    choose_kernel
    mount_mountpoints
    mount_other_mountpoints
    ask_desktop
    choose_desktop
    ask_bootloader
    ask_sudo_user
    ask_locale
    ask_timezone
    install_bases
    install_bootloader
    install_desktop
    add_sudo_user
    setup_locale
    setup_timezone
    enable_timesync
}

main "$@"
