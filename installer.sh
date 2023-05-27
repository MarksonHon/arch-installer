#!/bin/bash

RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)

home_path="$(pwd)"

download_installer(){
    echo "$GREEN""We will download the installer twice for checking sha256""$RESET"
    curl -L https://github.com/MarksonHon/arch-installer/archive/refs/heads/master.zip -o arch-installer.zip
    curl -L https://github.com/MarksonHon/arch-installer/archive/refs/heads/master.zip -o arch-installer.zip.2
    sha256_download_once="$(sha256sum ./arch-installer.zip)"
    sha256_download_twice="$(sha256sum ./arch-installer.zip.2)"
    if [ "$sha256_download_once" != "$sha256_download_twice" ];then
        echo "$RED""Failed to pass sha256 check, please try again!""$RESET"
        return 1
    fi
    unzip arch-installer.zip; rm arch-installer.zip*; chmod +x ./arch-installer/*sh; chmod +x ./arch-installer/bin/*sh
}

for tool in curl unzip git; do
    if ! command -v $tool> /dev/null 2>&1; then
        tool_need="$tool"" ""$tool_need"
    fi
done
if ! pacman -Sy "$tool_need";then
        echo "$RED""Use system package manager to install $tool_need failed,""$RESET"
        echo "$RED""You should install $tool_need then try again.""$RESET"
        exit 1
fi

if ! download_installer;then
    echo "$RED""Failed to download installer! Check your network and try again!""$RESET"
    exit 1
fi

echo "$YELLOW""The path of installer is $home_path""$RESET"
./arch-installer/bin/setup-arch.sh
