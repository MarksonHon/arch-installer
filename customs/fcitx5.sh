# See more in 
# https://fcitx-im.org/wiki/Using_Fcitx_5_on_Wayland
# https://fcitx-im.org/wiki/Setup_Fcitx_5
if command -v fcitx5 > /dev/null; then
    if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
        export XMODIFIERS=@im=fcitx5
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