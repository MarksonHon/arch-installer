#!/usr/bin/env bash

if [ $EUID = 0 ]; then
    echo "This script cannot be run as root!"
    echo "Please run this script as a normal user that can run as a sudoer."
    exit 1
fi

for tool in curl git; do
    if ! command -v $tool> /dev/null 2>&1; then
        tool_need="$tool"" ""$tool_need"
    fi
done

sudo pacman -Sy "$tool_need" --noconfirm

git clone https://github.com/MarksonHon/arch-installer/ /tmp/arch-installer
cd /tmp/arch-installer || exit 1

setup_paru(){
    if ! command -v paru > /dev/null 2>&1; then
        git clone https://aur.archlinux.org/paru-bin.git
        cd paru-bin || exit
        makepkg -si --noconfirm
        cd ..
        rm -rf paru-bin
    fi
}

setup_zsh(){
    sudo pacman -S pkgfile --noconfirm
    sudo pkgfile --update
    paru -S --noconfirm oh-my-posh-bin
    paru -S --noconfirm easy-zsh-config
    [ -f ~/.zshrc ] || cp customs/zshrc ~/.zshrc
    chsh -s /bin/zsh
}

setup_fcitx5(){
    sudo pacman -S fcitx5-im fcitx5-chinese-addons fcitx5-pinyin-zhwiki
    sudo cp customs/fcitx5.sh /etc/profile.d/
}

setup_pkgfile_hook(){
    paru -S --noconfirm pacman-pkgfile-hook
}

setup_flatpak(){
    sudo pacman -S flatpak --noconfirm
    sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    sudo cp customs/flatpak-fonts.sh /etc/profile.d/
}

setup_paru
setup_zsh
setup_pkgfile_hook
setup_fcitx5
setup_flatpak
[ -d ~/.config/fontconfig/ ] || mkdir -p ~/.config/fontconfig/
[ -f ~/.config/fontconfig/fonts.conf ] || cp customs/fonts.conf ~/.config/fontconfig/


echo "Done!"

cd ~ || exit
rm -rf /tmp/arch-installer