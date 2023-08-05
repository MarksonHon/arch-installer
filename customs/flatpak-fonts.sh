if [ -d ~/.var/app ]; then
    for FlatpakAppDir in ~/.var/app/*; do
        if [ ! -L "$FlatpakAppDir"/config/fontconfig ]; then
            ln -s ~/.config/fontconfig "$FlatpakAppDir"/config/
        fi
    done
fi