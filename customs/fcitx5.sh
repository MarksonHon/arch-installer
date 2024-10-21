# See more in 
# https://fcitx-im.org/wiki/Using_Fcitx_5_on_Wayland
# https://fcitx-im.org/wiki/Setup_Fcitx_5
# Set environment variables for fcitx5
if command -v fcitx5 > /dev/null; then
    if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
        export XMODIFIERS=@im=fcitx5
        export QT_IM_MODULES="wayland;fcitx;ibus"
        if [ "$XDG_CURRENT_DESKTOP" = "GNOME" ]; then
            export GTK_IM_MODULE=fcitx5
            export QT_IM_MODULE=fcitx5
        fi
    elif [ "$XDG_SESSION_TYPE" = "x11" ]; then
        export GTK_IM_MODULE=fcitx5
        export QT_IM_MODULE=fcitx5
        export XMODIFIERS=@im=fcitx5
    fi
fi
# GTK settings
if ! grep "\[Settings\]" < ~/.config/gtk-3.0/settings.ini > /dev/null; then
    echo "[Settings]" >> ~/.config/gtk-3.0/settings.ini
fi
if ! grep "gtk-im-module=fcitx" < ~/.config/gtk-3.0/settings.ini > /dev/null; then
    echo "gtk-im-module=fcitx" >> ~/.config/gtk-3.0/settings.ini
fi
if ! grep "\[Settings\]" < ~/.config/gtk-4.0/settings.ini > /dev/null; then
    echo "[Settings]" >> ~/.config/gtk-4.0/settings.ini
fi
if ! grep "gtk-im-module=fcitx" < ~/.config/gtk-4.0/settings.ini > /dev/null; then
    echo "gtk-im-module=fcitx" >> ~/.config/gtk-4.0/settings.ini
fi