#!/bin/bash

RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)

home_path="$(pwd)"

download_installer(){
    echo "$GREEN""We will download the installer twice for checking sha256""$RESET"
    curl -L https://github.com/MarksonHon/arch-install-scripts/archive/refs/heads/main.zip -o arch-installer.zip
    curl -L https://github.com/MarksonHon/arch-install-scripts/archive/refs/heads/main.zip -o arch-installer.zip.2
    sha256_download_once="$(sha256sum ./arch-installer.zip)"
    sha256_download_twice="$(sha256sum ./arch-installer.zip.2)"
    if [ "$sha256_download_once" != "$sha256_download_twice" ];then
        echo "$RED""Failed to pass sha256 check, please try again!""$RESET"
        return 1
    fi
    unzip arch-installer.zip; rm arch-installer.zip*
}

echo "$YELLOW""The path of installer is $home_path""$RESET"

if ! download_installer;then
    echo "$RED""Failed to download installer! Check your network and try again!""$RESET"
    exit
fi

./arch-installer/bin/setup-arch.sh
