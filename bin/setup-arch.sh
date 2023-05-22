#!/bin/bash

RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)

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
            echo "$YELLOW""You must make a choice!"
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
            echo "$YELLOW""You must make a choice!"
            kernel_name=""
            ask_kernel
        fi
    done
}