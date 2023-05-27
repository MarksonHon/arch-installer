#!/bin/bash

for tool in curl unzip git; do
    if ! command -v $tool> /dev/null 2>&1; then
        tool_need="$tool"" ""$tool_need"
    fi
done
/bin/bash -c "pacman -Sy $tool_need"

git clone https://github.com/MarksonHon/arch-installer/

cd ./arch-installer/ || exit 1

./setup-arch.sh
