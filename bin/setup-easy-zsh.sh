#!/bin/sh

install_easy_zsh(){
    arch-chroot /mnt /bin/bash -c "curl -# -LO https://github.com/MarksonHon/arch-installer/releases/download/v0.1.0/easy-zsh-config-0.6.1-1-any.pkg.tar.zst"
    arch-chroot /mnt /bin/bash -c "pacman -U easy-zsh-config-0.6.1-1-any.pkg.tar.zst --noconfirm"
    arch-chroot /mnt /bin/bash -c "rm easy-zsh-config-0.6.1-1-any.pkg.tar.zst"
    arch-chroot /mnt /bin/bash -c "curl -# -LO https://github.com/MarksonHon/arch-installer/releases/download/v0.1.0/oh-my-posh-bin-17.6.0-1-x86_64.pkg.tar.zst"
    arch-chroot /mnt /bin/bash -c "pacman -U oh-my-posh-bin-17.6.0-1-x86_64.pkg.tar.zst --noconfirm"
    arch-chroot /mnt /bin/bash -c "rm oh-my-posh-bin-17.6.0-1-x86_64.pkg.tar.zst"
}

install_paru(){
    arch-chroot /mnt /bin/bash -c "curl -# -LO https://github.com/MarksonHon/arch-installer/releases/download/v0.1.0/paru-bin-1.11.2-1-x86_64.pkg.tar.zst"
    arch-chroot /mnt /bin/bash -c "pacman -U paru-bin-1.11.2-1-x86_64.pkg.tar.zst --noconfirm"
    arch-chroot /mnt /bin/bash -c "rm paru-bin-1.11.2-1-x86_64.pkg.tar.zst"
}

install_pkgfile(){
    arch-chroot /mnt /bin/bash -c "pacman -S pkgfile zsh-completions --noconfirm"
    arch-chroot /mnt /bin/bash -c "pkgfile --update"
}

install_paru
install_easy_zsh
install_pkgfile
