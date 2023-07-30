if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    export MOZ_ENABLE_WAYLAND=1
    if command -v fcitx || command -v fcitx5; then
        export XMODIFIERS=@im=fcitx
    fi
fi