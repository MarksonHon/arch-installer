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
if ! (/bin/bash -c "pacman -Sy $tool_need");then
    echo "$RED""ERROR: Failed to install $tool_need, check your network settings or permission then try again!""$RESET"
    exit 1
fi

echo "$GREEN""-----------------------------------------------------------""$RESET"
echo "$GREEN""-----------------------------------------------------------""$RESET"
echo "Now you can install the Arch Linux!"
echo "Before installing, make sure you have the partition OK with fdisk or cfdisk,"
echo "and you have backup files before installing."
echo "$GREEN""-----------------------------------------------------------""$RESET"
echo "$GREEN""-----------------------------------------------------------""$RESET"

read -p "$YELLOW""Do you want to continue? Type \"yes\" to continue: ""$RESET" -r "RUOK"

if [ "$RUOK" == "yes" ]; then
    git clone https://github.com/MarksonHon/arch-installer/
    cd ./arch-installer/ || exit 1
    ./setup-arch.sh
fi