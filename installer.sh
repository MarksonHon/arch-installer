#!/bin/bash

RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)

ask_mirror_country(){
    echo "$YELLOW""Input your country/region to rank fastest mirror for you, such as Hong Kong, United States,""$RESET"
    echo "$YELLOW""You can get countries in this page: https://archlinux.org/mirrorlist""$RESET"
    read -p "$YELLOW""Input country/region: ""$RESET" -r "COUNTRY"
}

rank_mirror(){
    curl -sL "https://archlinux.org/mirrorlist/?&protocol=https&ip_version=4&ip_version=6" -o /tmp/mirrorlist
    while [ -z "$MIRROR_COUNTRY" ]; do
        ask_mirror_country
        check_country=$(cat /tmp/mirrorlist | grep "^## $COUNTRY")
        if [ -n "$check_country" ]; then
            MIRROR_COUNTRY="$COUNTRY"
        else
            echo "$RED""Your country/region is invaild, input again!""$RESET"
        fi
    done
    echo "$GREEN""Ranking fastest mirror for you, please wait...""$RESET"
    awk -v target="$MIRROR_COUNTRY" '$0 ~ ("^## " target "$"){f=1; next}f==0{next}/^$/{exit}{print substr($0, 1)}' /tmp/mirrorlist | sed 's/^#Server/Server/' > /tmp/mirrorlist-1
    rankmirrors -n 7 /tmp/mirrorlist-1 | tee /etc/pacman.d/mirrorlist
}

echo "$GREEN""-----------------------------------------------------------------------------""$RESET"
echo "$GREEN""-----------------------------------------------------------------------------""$RESET"
echo "Now you can install the Arch Linux!"
echo "Before installing, make sure you have the partition OK with fdisk or cfdisk,"
echo "and you have backup files before installing Arch Linux."
echo "This script will install Arch Linux for you, and you can choose to install"
echo "the desktop environment or not."
echo "However, this script is NOT a replacement for the official installation guide,"
echo "and you should read the official installation guide before using this script."
echo "The official installation guide is here: "
echo "https://wiki.archlinux.org/index.php/installation_guide" 
echo "This script is NOT part of the official installation guide,"
echo "use this script at your own risk."
echo "$GREEN""-----------------------------------------------------------------------------""$RESET"
echo "$GREEN""-----------------------------------------------------------------------------""$RESET"

read -p "$YELLOW""Do you want to continue? Type \"yes\" to continue: ""$RESET" -r "RUOK"

if [ "$RUOK" == "yes" ]; then
    for tool in curl pacman-contrib git; do
        if ! command -v $tool> /dev/null 2>&1; then
            tool_need="$tool"" ""$tool_need"
        fi
    done
    if [ -n "$tool_need" ]; then
        if ! (/bin/bash -c "pacman -Sy $tool_need --noconfirm");then
            echo "$RED""ERROR: Failed to install $tool_need, check your network settings or permission then try again!""$RESET"
            exit 1
        fi
    fi
    rank_mirror
    git clone https://github.com/MarksonHon/arch-installer/
    cd ./arch-installer/ || exit 1
    ./setup-arch.sh
fi

if [ -d arch-installer ]; then
    rm -rf arch-installer
fi