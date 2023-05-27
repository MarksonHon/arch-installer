#!/bin/bash

RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)

for tool in curl unzip git; do
    if ! command -v $tool> /dev/null 2>&1; then
        tool_need="$tool"" ""$tool_need"
    fi
done
/bin/bash -c "pacman -Sy $tool_need"

git clone https://github.com/MarksonHon/arch-installer/

cd ./arch-installer/

./setup-arch.sh
