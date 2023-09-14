#!/bin/bash

set -e

pacstrap /mnt plasma kde-system okular spectacle arianna gwenview ark kate konsole kwalletmanager kweather print-manager system-config-printer cups-pk-helper yakuake plasma-wayland-session falkon pipewire-pulse pipewire-jack noto-fonts-cjk noto-fonts-emoji noto-fonts-extra noto-fonts

arch-chroot /mnt /bin/bash -c "systemctl enable sddm.service"
arch-chroot /mnt /bin/bash -c "systemctl enable NetworkManager.service"
arch-chroot /mnt /bin/bash -c "systemctl enable bluetooth.service"

cp ./customs/wayland.sh /mnt/etc/profile.d/wayland.sh
cp ./customs/xdg-open /mnt/usr/local/bin/xdg-open

mkdir -p /mnt/etc/sddm.conf.d
echo '[General]
DisplayServer=wayland
GreeterEnvironment=QT_WAYLAND_SHELL_INTEGRATION=layer-shell
[Wayland]
CompositorCommand=kwin_wayland --no-lockscreen --no-global-shortcuts
' > /mnt/etc/sddm.conf.d/wayland.conf